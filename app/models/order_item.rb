class OrderItem < ApplicationRecord
  belongs_to :tech_card, required: false
  belongs_to :order
  before_save :set_tech_fields

  def self.front_view_with_name_key
    f_v = {}
    all.each do |order_item|
      f_v.merge!(order_item.front_view_with_key)
    end
    {orderItems: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |order_item|
      f_v.merge!(order_item.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {orderItems: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {orderItem: front_view}
  end

  def front_view
    as_json()
  end

  private

  def set_tech_fields
    self.techCardTitle = tech_card.title
    self.techCardPrice = tech_card.price
    self.summ = (techCardPrice * qty).round 2
  end
end
