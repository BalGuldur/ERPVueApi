class TechCard < ApplicationRecord
  include FrontViewSecond
  before_destroy :unlink_check_items
  has_many :check_items
  has_many :tech_card_items, dependent: :destroy
  has_and_belongs_to_many :store_menu_categories
  belongs_to :menu_category, required: false

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'check_items', type: 'many', rev_type: 'one', index_inc: false },
        { model: 'tech_card_items', type: 'many', rev_type: 'one', index_inc: true },
        { model: 'store_menu_categories', type: 'many', rev_type: 'many', index_inc: false },
    ]
  end

  # def self.front_view
  #   f_v = {}
  #   all.includes(:store_menu_categories, :tech_card_items).find_each do |ing|
  #     f_v.merge!(ing.id => ing.front_view)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:tech_card_item_ids, :store_menu_category_ids])
  # end
  #
  def fix_store(qty: 1)
    tech_card_items.fix_store(qty: qty)
  end

  private

  def unlink_check_items
    puts 'before destory'
    # check_items.update_all('tech_card_id = null')
    CheckItem.update(check_item_ids, [{tech_card: nil}])
  end
end
