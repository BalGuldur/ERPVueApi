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

  # Стандартный набор для генерации front_view
  def self.front_view_with_name_key
    f_v = {}
    all.each do |shift|
      f_v.merge!(shift.front_view_with_key)
    end
    {shifts: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |shift|
      f_v.merge!(shift.front_view_with_key)
    end
    f_v
  end

  def front_view_with_name_key
    {shifts: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:store_menu_cat_analitic_ids, :cash_box_analitic_ids])
  end
end
