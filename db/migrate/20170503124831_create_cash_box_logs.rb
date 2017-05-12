class CreateCashBoxLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :cash_box_logs do |t|
      t.references :cash_box, foreign_key: true
      t.float :oldCash
      t.float :newCash
      t.float :diff

      t.timestamps
    end
  end
end
