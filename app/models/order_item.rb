class OrderItem < ApplicationRecord
  include FrontViewSecond
  belongs_to :tech_card, required: false
  belongs_to :order
  # has_one :checks, through: :order
  before_save :set_tech_fields

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
    ]
  end

  def calc_summ
    self.summ = self.qty * self.techCardPrice
  end

  def store_tech_card
    self.techCardPrice = tech_card.price
    self.techCardTitle = tech_card.title
  end

  def self.new_by_item item
    # item: {qty: кол-во, tech_card_id: ID тех карты}
    @tech_card = TechCard.find(item[:tech_card_id])
    @order_item = new(qty: item[:qty], tech_card: @tech_card)
    @order_item.store_tech_card
    @order_item.calc_summ
    @order_item
  end

  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.find_each do |order_item|
  #     f_v.merge!(order_item.front_view_with_key)
  #   end
  #   {orderItems: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |order_item|
  #     f_v.merge!(order_item.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {orderItems: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view_with_name
  #   {orderItem: front_view}
  # end
  #
  # def front_view
  #   as_json()
  # end

  private

  def set_tech_fields
    self.techCardTitle = tech_card.title
    self.techCardPrice = tech_card.price
    self.summ = (techCardPrice * qty).round 2
  end
end
