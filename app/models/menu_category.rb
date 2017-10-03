class MenuCategory < ApplicationRecord
  include FrontViewSecond
  has_many :sub_categories, class_name: "MenuCategory", foreign_key: "parent_category_id", dependent: :destroy
  belongs_to :parent_category, class_name: "MenuCategory", required: false
  has_many :tech_cards

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
        { model: 'tech_cards', type: 'many', rev_type: 'one', index_inc: false },
        # { model: 'parent_category_id', type: 'one', rev_type: 'many', index_inc: false},
        { model: 'sub_categories', type: 'many', rev_type: 'one', index_inc: false}
    ]
  end

  def front_view_with_parent
    if parent_category.present?
      front_view.merge(parent_category.front_view){|key, old, new| old.merge new}
    else
      front_view
    end
  end
end
