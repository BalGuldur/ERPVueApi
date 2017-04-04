class Supply < ApplicationRecord
  has_many :supply_items
  has_many :ingredients, through: :supply_items
  has_many :store_items, through: :ingredients
end
