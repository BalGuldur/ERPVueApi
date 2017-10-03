# rubocop:disable Style/AsciiComments
# Класс отвечающий за ингредиенты
class Ingredient < ApplicationRecord
  # Импорт стандартного front view
  include FrontViewSecond

  has_one :store_item, dependent: :destroy
  has_and_belongs_to_many :store_menu_categories
  has_many :supply_items
  has_many :tech_card_items

  def self.refs
    [
      { model: 'store_item', type: 'one', rev_type: 'one', index_inc: false },
      { model: 'store_menu_categories', type: 'many', rev_type: 'many', index_inc: false },
      { model: 'supply_items', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  # def self.front_view
  #   f_v = {}
  #   all.includes(:store_item, :store_menu_categories).find_each do |ing|
  #     f_v.merge!(ing.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:store_item_id, :store_menu_category_ids])
  # end
  #
  def store_item_id
    store_item.present? ? store_item.id : nil
  end
end
