class AddMenuCategoryReferenceToTechCard < ActiveRecord::Migration[5.0]
  def change
    add_reference :tech_cards, :menu_category, foreign_key: true
  end
end
