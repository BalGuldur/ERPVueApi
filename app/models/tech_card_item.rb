class TechCardItem < ApplicationRecord
  belongs_to :tech_card
  belongs_to :ingredient

  def self.front_view
    f_v = {}
    all.each do |ing|
      f_v.merge!(ing.front_view_with_key)
    end
    f_v
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json
  end

  def self.fix_store
    all.each do |tech_card_item|
      tech_card_item.fix_store
    end
  end

  def fix_store
    @store_item = ingredient.store_item
    if @store_item.present?
      @store_item.remains = @store_item.remains - qty
      @store_item.save
    end
  end
end
