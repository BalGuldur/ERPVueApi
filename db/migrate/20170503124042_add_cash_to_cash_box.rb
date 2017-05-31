class AddCashToCashBox < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_boxes, :cash, :float
  end
end
