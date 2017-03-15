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
end
