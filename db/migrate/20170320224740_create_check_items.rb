class CreateCheckItems < ActiveRecord::Migration[5.0]
  def change
    create_table :check_items do |t|
      t.integer :discount
      t.string :tech_card_title
      t.float :tech_card_price
      t.integer :qty
      t.float :amount_paid
      t.references :tech_card, foreign_key: true
      t.references :check, foreign_key: true

      t.timestamps
    end
  end
end
