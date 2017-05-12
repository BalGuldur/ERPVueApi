class AddEncashPercentToCashBox < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_boxes, :encashPercent, :float
  end
end
