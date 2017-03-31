class TechCard < ApplicationRecord
  before_destroy :unlink_check_items
  has_many :check_items
  has_many :tech_card_items, dependent: :destroy
  has_and_belongs_to_many :store_menu_categories

  def self.front_view
    f_v = {}
    all.each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:tech_card_item_ids, :store_menu_category_ids])
  end

  def fix_store
    tech_card_items.fix_store
  end

  private

  def unlink_check_items
    puts 'before destory'
    check_items.update_all('tech_card_id = null')
  end
end
