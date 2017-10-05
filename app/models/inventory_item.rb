class InventoryItem < ApplicationRecord
  include FrontViewSecond
  belongs_to :inventory
  belongs_to :ingredient

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
    ]
  end

  def store_merge
    @store_item = StoreItem.find(store_item_id)
    @store_item.remains += diffQty
    saved = @store_item.save!
    errors << {store_item: 'error on store_merge'} if !saved
    return saved
  end
end
