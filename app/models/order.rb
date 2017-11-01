class Order < ApplicationRecord
  include FrontViewSecond
  belongs_to :open_place, required: false
  has_many :order_items, dependent: :destroy
  has_many :checks, dependent: :destroy
  has_many :check_items, through: :checks
  scope :not_paid, -> {includes(:checks).where('checks' => {paidOn: nil})}
  before_save :set_summ

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        { model: 'order_items', type: 'many', rev_type: 'one', index_inc: true },
        { model: 'checks', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  def add_items items
    # items: [{qty: кол-во, tech_card_id: ID тех карты}]
    items.each do |item|
      order_items << OrderItem.new_by_item(item)
    end
    self.calc_summ
    true
  end

  def calc_summ
    summ = 0
    self.order_items.each {|item| summ += item.summ}
  end

  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.includes(:order_items, :checks).find_each do |order|
  #     f_v.merge!(order.front_view_with_key)
  #   end
  #   {orders: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |order|
  #     f_v.merge!(order.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {orders: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view_with_name
  #   {order: front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:order_item_ids, :check_ids])
  # end

  private

  def set_summ
    summ = 0
    order_items.each do |order_item|
      summ = summ + (order_item.tech_card.price * order_item.qty).round(2)
    end
    self.summ = summ
  end
end
