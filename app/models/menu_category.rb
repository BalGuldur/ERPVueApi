class MenuCategory < ApplicationRecord
  include FrontView
  has_many :sub_categories, class_name: "MenuCategory", foreign_key: "parent_category_id", dependent: :destroy
  belongs_to :parent_category, class_name: "MenuCategory", required: false
  has_many :tech_cards

  def front_view_with_parent
    if parent_category.present?
      front_view.merge(parent_category.front_view){|key, old, new| old.merge new}
    else
      front_view
    end
  end
end
