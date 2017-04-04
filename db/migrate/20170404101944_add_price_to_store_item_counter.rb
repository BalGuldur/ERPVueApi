class AddPriceToStoreItemCounter < ActiveRecord::Migration[5.0]
  def change
    add_column :store_item_counters, :storeOldPrice, :float
    add_column :store_item_counters, :storeNewPrice, :float
  end
end
