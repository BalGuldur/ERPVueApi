class AddQtyDiffToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :diffQty, :float
    add_column :inventory_items, :storeQty, :float
  end
end
