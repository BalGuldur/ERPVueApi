class AddDiffCashToCashBoxAnalitic < ActiveRecord::Migration[5.0]
  def change
    add_column :cash_box_analitics, :diffCash, :float
  end
end
