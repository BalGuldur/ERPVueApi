class CreateEncashLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :encash_logs do |t|
      t.float :oldCash
      t.float :newCash
      t.float :encashPercent
      t.float :encashPaid
      t.references :cash_box, foreign_key: true

      t.timestamps
    end
  end
end
