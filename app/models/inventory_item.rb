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

  # def self.front_view
  #   f_v = {}
  #   all.each do |ing|
  #     f_v.merge!(ing.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:inventory_id, :ingredient_id])
  # end

  def store_merge
    @store_item = StoreItem.find(store_item_id)
    @store_item.remains = qty
    saved = @store_item.save
    errors << {store_item: 'error on store_merge'} if !saved
    return saved
  end
end
