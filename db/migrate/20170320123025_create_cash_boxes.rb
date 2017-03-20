class CreateCashBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :cash_boxes do |t|
      t.string :title
      t.integer :discount

      t.timestamps
    end
  end
end
