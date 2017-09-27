# rubocop:disable Style/AsciiComments
# Класс отвечающий за ингредиенты
class Ingredient < ApplicationRecord
  # Импорт стандартного front view
  include FrontView

  has_one :store_item, dependent: :destroy
  has_and_belongs_to_many :store_menu_categories
  has_many :supply_items

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
