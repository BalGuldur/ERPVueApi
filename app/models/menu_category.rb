class MenuCategory < ApplicationRecord
  has_many :sub_categories, class_name: "MenuCategory", foreign_key: "parent_category_id", dependent: :destroy
  belongs_to :parent_category, class_name: "MenuCategory", required: false
  has_many :tech_cards

  def self.front_view_with_name_key
    f_v = {}
    all.each do |menu_category|
      f_v.merge!(menu_category.front_view_with_key)
    end
    {menuCategories: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |menu_category|
      f_v.merge!(menu_category.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {menuCategory: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {menuCategory: front_view}
  end

  def front_view
    as_json(methods: [:parent_category_id, :sub_category_ids, :tech_card_ids])
  end
end
