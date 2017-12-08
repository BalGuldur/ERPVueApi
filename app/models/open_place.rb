# rubocop:disable Style/AsciiComments
# Класс отвечающий за столы
class OpenPlace < ApplicationRecord
  include FrontViewSecond
  before_destroy :reset_place_reference
  before_create :create_empty_order
  before_create :create_client_if_empty

  acts_as_paranoid

  has_many :places
  has_many :orders

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
      { model: 'places', type: 'many', rev_type: 'one', index_inc: false },
      { model: 'orders', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  # Закрытие стола
  def close
    # TODO: Добавить сохранение истории открытых столов
    destroy
  end

  def create_empty_order
    @order = Order.create(client: name)
    orders << @order
  end

  def last_or_new_order
    orders.present? ? orders.last : Order.new(client: name, open_place: self)
  end

  def add_hookah_order items
    items.each {|item| puts item.as_json}
    transaction do
      @order = last_or_new_order
      @order.add_items items
      @order.save!
    end
  end

  private

  def reset_place_reference
    places.find_each { |place| place.update open_place_id: nil }
  end

  def create_client_if_empty
    Client.create(name: name, phones: [phone]) if Client.phone_present? phone
  end
end
