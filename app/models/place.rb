# rubocop:disable Style/AsciiComments
# Класс отвечающий за столы
class Place < ApplicationRecord
  acts_as_paranoid

  belongs_to :hall
  belongs_to :open_place, required: false
  has_and_belongs_to_many :booking_places
  include FrontView

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
