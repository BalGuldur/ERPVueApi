# rubocop:disable Style/AsciiComments
# Класс отвечающий за
class CashBoxAnalitic < ApplicationRecord
  # Добавление стандартного FrontView
  include FrontViewSecond

  belongs_to :shift
  belongs_to :cash_box

  serialize :cashBoxSave

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
    ]
  end

  def fix_cash purchaseSumm, notPaidStaffSumm
    transaction do
      self.cash = cash_box.cash
      self.cashBoxSave = cash_box.as_json
      # TODO: Сделать checkbox
      self.purchaseSumm = if cash_box.title == 'Наличные'
                            purchaseSumm
                          else
                            0
                          end
      self.notPaidStaffSumm = if cash_box.title == 'Наличные'
                                notPaidStaffSumm
                              else
                                0
                              end
      set_diff_cash
      cash_box.encash cash
      save!
    end
  end

  def set_diff_cash
    self.diffCash = cash - realCash - purchaseSumm - notPaidStaffSumm
  end

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
