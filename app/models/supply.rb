class Supply < ApplicationRecord
  include FrontView

  has_many :supply_items, dependent: :destroy
  has_many :ingredients, through: :supply_items
  has_many :store_items, through: :ingredients

  def revert
    if performed
      transaction do
        supply_items.find_each &:revert
        self.performed = false
        save!
      end
    else
      errors.add(:revert, 'Поставка уже отменена')
      false
    end
  end

  def perform
    if performed
      errors.add(:perform, 'Поставка уже проведена')
      false
    else
      transaction do
        supply_items.find_each &:perform
        self.performed = true
        save!
      end
    end
  end

  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.find_each do |supply|
  #     f_v.merge!(supply.front_view_with_key)
  #   end
  #   {supplies: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.find_each do |supply|
  #     f_v.merge!(supply.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {supply: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view_with_name
  #   {waste: front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:supply_item_ids, :ingredient_ids, :store_item_ids])
  # end
end
