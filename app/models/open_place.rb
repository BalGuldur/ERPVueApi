# rubocop:disable Style/AsciiComments
# Класс отвечающий за столы
class OpenPlace < ApplicationRecord
  before_destroy :reset_place_reference
  before_create :create_empty_order

  acts_as_paranoid

  has_many :places
  has_many :orders

  # Закрытие стола
  def close
    # TODO: Добавить сохранение истории открытых столов
    destroy
  end

  # Стандартный вывод для front_view
  def self.front_view
    f_v = {}
    all.includes(:places).find_each do |open_place|
      f_v.merge!(open_place.front_view[:openPlaces])
    end
    { openPlaces: f_v }
  end

  def front_view
    { openPlaces: { id => json_front } }
  end

  def json_front
    as_json(methods: [:place_ids, :order_ids])
  end

  private

  def reset_place_reference
    places.find_each { |place| place.update open_place_id: nil }
  end

  def create_empty_order
    @order = Order.create(client: name)
    self.orders << @order
  end
end
