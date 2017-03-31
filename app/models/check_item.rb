class CheckItem < ApplicationRecord
  after_create :fix_store

  belongs_to :check
  belongs_to :tech_card, required: false

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
    as_json(methods: [:tech_card_id])
  end

  private

  def fix_store
    tech_card.fix_store(qty: qty)
  end
end
