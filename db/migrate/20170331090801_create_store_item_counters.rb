class CreateStoreItemCounters < ActiveRecord::Migration[5.0]
  def change
    create_table :store_item_counters do |t|
      t.references :store_item, foreign_key: true
      t.float :storeNewQty
      t.float :storeOldQty

      t.timestamps
    end
  end
end
