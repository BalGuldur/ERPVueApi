class CreateSupplyItems < ActiveRecord::Migration[5.0]
  def change
    create_table :supply_items do |t|
      t.references :supply, foreign_key: true
      t.float :qty
      t.float :summ
      t.float :price
      t.string :ingTitle
      t.references :ingredient
      t.references :store_item

      t.timestamps
    end
  end
end
