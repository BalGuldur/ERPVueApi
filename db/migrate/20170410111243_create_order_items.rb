class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.integer :qty
      t.references :tech_card, foreign_key: true
      t.string :techCardTitle
      t.float :techCardPrice
      t.float :summ

      t.timestamps
    end
  end
end
