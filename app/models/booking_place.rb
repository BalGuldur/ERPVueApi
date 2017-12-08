# rubocop:disable Style/AsciiComments
# Класс отвечающий за Брони столов
class BookingPlace < ApplicationRecord
  include FrontViewSecond
  before_destroy :reset_place_reference
  before_create :create_client_if_empty

  acts_as_paranoid

  has_and_belongs_to_many :places

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        { model: 'places', type: 'many', rev_type: 'many', index_inc: false }
    ]
  end

  # Закрытие брони
  def close
    # TODO: Добавить сохранение истории забронированных столов
    destroy
  end

  def open
    transaction do
      @open_place = OpenPlace.new(openTime: DateTime.now(),
                                  countGuests: countGuests,
                                  places: places,
                                  name: name,
                                  phone: phone)
      @open_place.save!
      destroy
    end
  end

  private

  def reset_place_reference
    update places: []
  end

  def create_client_if_empty
    Client.create(name: name, phones: [phone]) if Client.phone_present? phone
  end
end
