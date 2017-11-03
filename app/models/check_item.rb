class CheckItem < ApplicationRecord
  # after_create :fix_store
  include FrontViewSecond

  belongs_to :check
  belongs_to :tech_card, required: false

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
    ]
  end

  def self.store_cat_analitic_v2(array_cat_title)
    result = {}
    array_cat_title.each do |cat_title|
      stmncat = StoreMenuCategory.find_by(title: cat_title)
      check_items_ass = where(tech_card_id: stmncat.tech_cards.ids)
      summ = check_items_ass.sum(:summ)
      qty = check_items_ass.sum(:qty)
      result[cat_title] = {summ: summ, qty: qty}
    end
    result
  end

  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.includes(:tech_card).find_each do |check_item|
  #     f_v.merge!(check_item.front_view_with_key)
  #   end
  #   {checkItems: f_v}
  # end
  #
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
  #   as_json(methods: [:tech_card_id])
  # end

  def fix_store
    tech_card.fix_store(qty: qty)
  end

  def fix_cat_analitic
    tech_card.store_menu_categories.each do |stMenCat|
      @store_menu_analitic = StoreMenuCatAnalitic.new(
        shift: check.shift,
        store_menu_category: stMenCat,
        qty: qty,
        summ: summ,
        storeMenuCategorySave: stMenCat.as_json
      )
      @store_menu_analitic.save!
    end
  end

  private

  # def fix_store
  #   tech_card.fix_store(qty: qty)
  # end
end
