# rubocop:disable Style/AsciiComments
# Класс отвечающий за столы
class Place < ApplicationRecord
  acts_as_paranoid

  belongs_to :hall
  belongs_to :open_place, required: false
  has_and_belongs_to_many :booking_places
  include FrontViewSecond

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
        { model: 'booking_places', type: 'many', rev_type: 'many', index_inc: false }
    ]
  end

  # # Стандартный вывод для front_view
  # def self.front_view
  #   f_v = {}
  #   all.includes(:booking_places).find_each do |place|
  #     f_v.merge!(place.front_view[:places])
  #   end
  #   { places: f_v }
  # end
  #
  # def front_view
  #   { places: { id => json_front } }
  # end
  #
  # def json_front
  #   as_json(methods: [:booking_place_ids])
  # end
end
