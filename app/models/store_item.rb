class StoreItem < ApplicationRecord
  include FrontViewSecond
  after_update :set_counter
  after_create :set_counter
  belongs_to :ingredient
  has_many :waste_items, dependent: :destroy
  has_many :store_item_counters, dependent: :destroy

  def self.refs
    []
  end

  def self.add_supply(params)
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

  private

  def set_counter
    @store_item_counter = StoreItemCounter.new(
      store_item: self,
      storeOldQty: remains_was,
      storeNewQty: remains,
      storeOldPrice: price_was,
      storeNewPrice: price
    )
    @store_item_counter.save
  end
end
