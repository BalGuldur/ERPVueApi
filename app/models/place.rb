# rubocop:disable Style/AsciiComments
# Класс отвечающий за столы
class Place < ApplicationRecord
  acts_as_paranoid

  belongs_to :hall
  belongs_to :open_place, required: false

  # Стандартный вывод для front_view
  def self.front_view
    f_v = {}
    all.find_each do |place|
      f_v.merge!(place.front_view[:places])
    end
    { places: f_v }
  end

  def front_view
    { places: { id => json_front } }
  end

  def json_front
    as_json
  end
end
