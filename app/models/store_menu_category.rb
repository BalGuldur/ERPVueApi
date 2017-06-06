class StoreMenuCategory < ApplicationRecord
  has_and_belongs_to_many :ingredients
  has_and_belongs_to_many :tech_cards
  has_many :store_menu_cat_analitics

  def self.front_view
    f_v = {}
    all.includes(:ingredients, :tech_cards).find_each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:ingredient_ids, :tech_card_ids])
  end
end
