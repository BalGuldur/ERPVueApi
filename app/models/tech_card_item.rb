class TechCardItem < ApplicationRecord
  include FrontViewSecond
  belongs_to :tech_card
  belongs_to :ingredient

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
  [
    # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
    { model: 'ingredient', type: 'one', rev_type: 'many', index_inc: false }
  ]
  end

  # def self.front_view
  #   f_v = {}
  #   all.find_each do |ing|
  #     f_v.merge!(ing.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json
  # end

  def self.fix_store(qty: 1)
    all.each do |tech_card_item|
      tech_card_item.fix_store(count: qty)
    end
  end

  def fix_store(count: 1)
    @store_item = ingredient.store_item
    if @store_item.present?
      @store_item.remains = (@store_item.remains || 0) - (qty * count)
      @store_item.save
    end
  end
end
