class CreateChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :checks do |t|
      t.string :client
      t.float :summ
      t.string :cash_box_title
      t.integer :cash_box_discount
      t.references :cash_box, foreign_key: true

      t.timestamps
    end
  end
end
