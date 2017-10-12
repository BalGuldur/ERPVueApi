# rubocop:disable Style/AsciiComments
# Класс отвечающий за
class CashBox < ApplicationRecord
  # Добавление стандартного FrontView
  include FrontViewSecond

  has_many :cash_box_logs, dependent: :destroy
  has_many :cash_box_analitics

  # Определение связей для front_view
  def self.refs
    # Если буду добавлять очень нагружающие logs и analitics то делать это отдельным запросом в controller
    []
  end

  def change_cash amountChange = 0, object_id = nil
    oldCash = self.cash
    newCash = (cash || 0) + amountChange
    self.cash = newCash
    log = CashBoxLog.new oldCash: oldCash, newCash: newCash, diff: amountChange, object_id: object_id
    self.cash_box_logs << log
  # TODO: Добавить cash log
    self.save!
  end

  def encash amount
    @amount = 0 - (amount || 0)
    self.change_cash @amount
  end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |ing|
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
end
