# rubocop:disable Style/AsciiComments
# Класс отвечающий за
class CashBoxAnalitic < ApplicationRecord
  # Добавление стандартного FrontView
  include FrontViewSecond

  belongs_to :shift
  belongs_to :cash_box

  serialize :cashBoxSave

  # # Стандартный набор для генерации front_view
  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.each do |cash_box_analitic|
  #     f_v.merge!(cash_box_analitic.front_view_with_key)
  #   end
  #   {cashBoxAnalitics: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |cash_box_analitic|
  #     f_v.merge!(cash_box_analitic.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {cashBoxAnalitics: front_view_with_key}
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
