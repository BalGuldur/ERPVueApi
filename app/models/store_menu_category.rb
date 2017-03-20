class StoreMenuCategory < ApplicationRecord
  has_and_belongs_to_many :ingredients
  has_and_belongs_to_many :tech_cards
end
