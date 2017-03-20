class CreateJoinTableStoreMenuCategoryTechCard < ActiveRecord::Migration[5.0]
  def change
    create_join_table :store_menu_categories, :tech_cards do |t|
      t.index [:store_menu_category_id, :tech_card_id], name: :st_mn_cat_tch_card
      t.index [:tech_card_id, :store_menu_category_id], name: :tch_card_st_mn_cat
    end
  end
end
