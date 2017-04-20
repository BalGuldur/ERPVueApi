class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :checks, dependent: :destroy
  has_many :check_items, through: :checks
  scope :not_paid, -> {includes(:checks).where(checks: {paidOn: nil})}
  before_save :set_summ

  def self.front_view_with_name_key
    f_v = {}
    all.each do |order|
      f_v.merge!(order.front_view_with_key)
    end
    {orders: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |order|
      f_v.merge!(order.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {orders: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view_with_name
    {order: front_view}
  end

  def front_view
    as_json(methods: [:order_item_ids, :check_ids])
  end

  private

  def set_summ
    summ = 0
    order_items.each do |order_item|
      summ = summ + (order_item.tech_card.price * order_item.qty).round(2)
    end
    self.summ = summ
  end
end
