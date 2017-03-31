class StoreItem < ApplicationRecord
  after_update :set_counter
  after_create :set_counter
  belongs_to :ingredient

  def self.add_supply params
    ingredient = Ingredient.find(params[:ingredient_id])
    price = params[:price]
    remains = params[:remains]

    if ingredient.store_item.present?
      old_store_item = ingredient.store_item
      old_store_item.price = ((old_store_item.price * old_store_item.remains) + price.to_f) / (old_store_item.remains + remains.to_f)
      old_store_item.remains = old_store_item.remains + remains.to_f
      return old_store_item
    else
      store_item = StoreItem.new(ingredient: ingredient, price: price.to_f / remains.to_f, remains: remains.to_f)
      return store_item
    end
  end

  def self.front_view
    f_v = {}
    all.each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json
  end

  private

  def set_counter
    puts "remains was #{remains_was}"
    puts "remains now #{remains}"
    @store_item_counter = StoreItemCounter.new(store_item: self, storeOldQty: remains_was, storeNewQty: remains)
    @store_item_counter.save
  end
end
