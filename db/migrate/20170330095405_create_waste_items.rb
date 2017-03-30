class CreateWasteItems < ActiveRecord::Migration[5.0]
  def change
    create_table :waste_items do |t|
      t.references :waste, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.references :store_item, foreign_key: true
      t.float :storeItemPrice
      t.string :ingMeasure
      t.float :qty
      t.float :price

      t.timestamps
    end
  end
end
