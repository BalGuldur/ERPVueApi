# rubocop:disable Style/AsciiComments
# Класс отвечающий за залы
class Hall < ApplicationRecord
  include FrontViewSecond
  acts_as_paranoid

  has_many :places, dependent: :destroy

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
        { model: 'places', type: 'many', rev_type: 'one', index_inc: true }
    ]
  end

  # # Стандартный вывод для front_view
  # def self.front_view
  #   f_v = {}
  #   # Для избежания N+1 запроса выгружаем front_view зависимых сущностей
  #   places_f_v = Place.joins(:hall).where(halls: { id: [ids] }).front_view
  #   # all.includes(:store_menu_categories, :tech_card_items).find_each
  #   includes(:places).find_each do |hall|
  #     hall_f_v = hall.front_view with_childs: false
  #     f_v.merge!(hall_f_v[:halls])
  #   end
  #   { halls: f_v }.merge!(places_f_v)
  # end
  #
  # def front_view(with_childs: true)
  #   result = { halls: { id => json_front } }
  #   if with_childs
  #     pl = places.present? ? places.front_view : { places: {} }
  #     result.merge!(pl)
  #   end
  #   result
  # end
  #
  # def json_front
  #   as_json methods: [:place_ids]
  # end
end
