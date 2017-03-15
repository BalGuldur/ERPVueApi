class CreateStoreItems < ActiveRecord::Migration[5.0]
  def change
    create_table :store_items do |t|
      t.float :price
      t.float :remains
      t.references :ingredient, foreign_key: true

      t.timestamps
    end
  end
end
