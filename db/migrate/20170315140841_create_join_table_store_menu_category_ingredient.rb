class CreateJoinTableStoreMenuCategoryIngredient < ActiveRecord::Migration[5.0]
  def change
    create_join_table :store_menu_categories, :ingredients do |t|
      t.index [:store_menu_category_id, :ingredient_id], name: :st_mn_cat_to_ing
      t.index [:ingredient_id, :store_menu_category_id], name: :ing_to_st_mn_cat
    end
  end
end
