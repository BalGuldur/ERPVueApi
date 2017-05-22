class CreateStoreMenuCatAnalitics < ActiveRecord::Migration[5.0]
  def change
    create_table :store_menu_cat_analitics do |t|
      t.references :shift, foreign_key: true
      t.references :store_menu_category, foreign_key: true
      t.integer :qty
      t.float :summ
      t.text :storeMenuCategorySave

      t.timestamps
    end
  end
end
