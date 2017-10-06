class StoreMenuCatAnalitic < ApplicationRecord
  include FrontViewSecond
  belongs_to :shift
  belongs_to :store_menu_category

  serialize :storeMenuCategorySave

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
    ]
  end

  # # Стандартный набор для генерации front_view
  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.find_each do |store_menu_cat_analitic|
  #     f_v.merge!(store_menu_cat_analitic.front_view_with_key)
  #   end
  #   {storeMenuCatAnalitics: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |store_menu_cat_analitic|
  #     f_v.merge!(store_menu_cat_analitic.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {storeMenuCatAnalitics: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json
  # end
end
