class AddChangePriceToSupplyItem < ActiveRecord::Migration[5.0]
  def change
    add_column :supply_items, :changePrice, :float
  end
end
