class Shift < ApplicationRecord
  belongs_to :work_day
  # TODO: Подумать над dependent: :destroy
  has_many :cash_box_analitics, dependent: :destroy
  has_many :store_menu_cat_analitics, dependent: :destroy
  has_many :checks, dependent: :destroy

  def store_cat_analitic
    self.store_menu_cat_analitics.includes(:store_menu_category).group(:title).sum(:qty)
  end

  def close employee, cashBoxes
    transaction do
      self.closeOn = DateTime.now
      # Сохраняем для избежания пересечения данных
      save!
      self.employee = employee
      CashBox.all.each do |cashBox|
        # TODO: Проверить необходимость to_s
        @realCash = cashBoxes[cashBox.id.to_s] && cashBoxes[cashBox.id.to_s]['realCash']
        @purchaseSumm = cashBoxes[cashBox.id.to_s] && cashBoxes[cashBox.id.to_s]['purchaseSumm']
        @cash = cashBox.cash
        @cash_box_analitic = CashBoxAnalitic.new(
          cash: @cash,
          cash_box: cashBox,
          cashBoxSave: cashBox.as_json,
          purchaseSumm: @purchaseSumm,
          realCash: @realCash,
          shift: self
        )
        @cash_box_analitic.save!
        cashBox.encash @cash
      end

      save!
    end
  end
end
