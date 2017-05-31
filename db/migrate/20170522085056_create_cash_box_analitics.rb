class CreateCashBoxAnalitics < ActiveRecord::Migration[5.0]
  def change
    create_table :cash_box_analitics do |t|
      t.references :shift, foreign_key: true
      t.references :cash_box, foreign_key: true
      t.text :cashBoxSave
      t.float :realCash
      t.float :cash
      t.float :purchaseSumm

      t.timestamps
    end
  end
end
