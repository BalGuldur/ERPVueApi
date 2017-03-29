class InventoryItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :ingredient

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
    as_json(methods: [:inventory_id, :ingredient_id])
  end

  def store_merge
    @store_item = StoreItem.find(store_item_id)
    @store_item.remains = qty
    saved = @store_item.save
    errors << {store_item: 'error on store_merge'} if !saved
    return saved
  end
end
