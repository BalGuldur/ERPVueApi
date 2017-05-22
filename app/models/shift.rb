class Shift < ApplicationRecord
  belongs_to :work_day
  has_many :cash_box_analitics
  has_many :store_menu_cat_analitics
  has_many :checks
end
