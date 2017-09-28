class AddDiffSummToInventoryItem < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_items, :diffSumm, :float
  end
end
