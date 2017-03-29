class AddStoreIdToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :store_item_id, :integer
  end
end
