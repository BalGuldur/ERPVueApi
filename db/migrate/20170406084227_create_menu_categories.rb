class CreateMenuCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_categories do |t|
      t.string :title
      t.references :parent_category, index: true

      t.timestamps
    end
  end
end
