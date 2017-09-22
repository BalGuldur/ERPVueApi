# rubocop:disable Style/AsciiComments
# Класс отвечающий за Брони столов
class BookingPlace < ApplicationRecord
  before_destroy :reset_place_reference

  acts_as_paranoid

  has_and_belongs_to_many :places

  # Закрытие брони
  def close
    # TODO: Добавить сохранение истории забронированных столов
    destroy
  end

  # Стандартный вывод для front_view
  def self.front_view
    f_v = {}
    all.includes(:places).find_each do |booking_place|
      f_v.merge!(booking_place.front_view[:bookingPlaces])
    end
    { bookingPlaces: f_v }
  end

  def front_view
    { bookingPlaces: { id => json_front } }
  end

  def json_front
    as_json(methods: [:place_ids])
  end

  private

  def reset_place_reference
    # places.find_each { |place| place.update open_place_id: nil }
    update places: []
  end
end
