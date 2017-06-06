class CheckItem < ApplicationRecord
  # after_create :fix_store

  belongs_to :check
  belongs_to :tech_card, required: false

  def self.front_view_with_name_key
    f_v = {}
    all.find_each do |check_item|
      f_v.merge!(check_item.front_view_with_key)
    end
    {checkItems: f_v}
  end

  def self.front_view
    f_v = {}
    all.find_each do |ing|
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
