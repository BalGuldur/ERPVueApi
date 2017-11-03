class AddNotPaidClientsSummToCashBoxAnalitic < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_box_analitics, :notPaidClientsSumm, :float
  end
end
