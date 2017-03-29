class CreateInventoryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_items do |t|
      t.references :inventory, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.float :qty
      t.text :comment

      t.timestamps
    end
  end
end
