class CreateStoreMenuCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :store_menu_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
