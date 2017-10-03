# rubocop:disable Style/AsciiComments
# Класс отвечающий за
class CashBoxLog < ApplicationRecord
  # Добавление стандартного FrontView
  include FrontViewSecond

  belongs_to :cash_box
end
