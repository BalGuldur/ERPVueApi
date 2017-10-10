class Shift < ApplicationRecord
  include FrontViewSecond
  belongs_to :work_day
  # TODO: Подумать над dependent: :destroy
  has_many :cash_box_analitics, dependent: :destroy
  has_many :store_menu_cat_analitics, dependent: :destroy
  has_many :checks, dependent: :destroy

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
        { model: 'checks', type: 'many', rev_type: 'one', index_inc: false },
        { model: 'cash_box_analitics', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  def store_cat_analitic
    self.store_menu_cat_analitics.includes(:store_menu_category).group(:title).sum(:qty)
  end

  def close(employee, purchaseSumm, cashBoxes)
    transaction do
      self.closeOn = DateTime.now
      # Сохраняем для избежания пересечения данных
      save!
      self.employee = employee
      CashBox.all.each do |cashBox|
        # TODO: Проверить необходимость to_s
        @realCash = cashBoxes[cashBox.id.to_s] && cashBoxes[cashBox.id.to_s]['realCash']
        if @realCash
          @cash_box_analitic = CashBoxAnalitic.new(cash_box: cashBox, realCash: @realCash, shift: self)
          @cash_box_analitic.fix_cash(purchaseSumm)
        end
        # @purchaseSumm = cashBoxes[cashBox.id.to_s] && cashBoxes[cashBox.id.to_s]['purchaseSumm']
        # @cash = cashBox.cash
        # @cash_box_analitic = CashBoxAnalitic.new(
        #   cash: @cash,
        #   cash_box: cashBox,
        #   cashBoxSave: cashBox.as_json,
        #   purchaseSumm: @purchaseSumm,
        #   realCash: @realCash,
        #   shift: self
        # )
        # @cash_box_analitic.save!
        # cashBox.encash @cash_box_analitic
      end
      save!
    end
  end

  # # Стандартный набор для генерации front_view
  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.includes(:store_menu_cat_analitics, :cash_box_analitics).find_each do |shift|
  #     f_v.merge!(shift.front_view_with_key)
  #   end
  #   {shifts: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |shift|
  #     f_v.merge!(shift.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {shifts: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:store_menu_cat_analitic_ids, :cash_box_analitic_ids])
  # end
  #
  # def file_name
  #   return "#{id}-#{DateTime.now}-shift.pdf"
  # end

  def printer
    CupsPrinter.new(CupsPrinter.get_all_printer_names.first)
  end

  # Высота бумаги распечатаемого чека (используется в контроллере checks print)
  def height_page
    # Генерирация высоты чека
    # header_size = 20
    # footer_size = 40
    # order_size = self.check_items.count * 20
    # page_height = header_size + footer_size + order_size
    page_height = 150
    # Если высота чека меньше ширины выставляем высоту больше, для получения landscape ориентации
    page_height = 82 if page_height < 82
    return page_height
  end

  # Печать чека
  def print file_name
    job = printer.print_file 'public/shifts/' + file_name
    # Для избежания ошибки операции << на nil объекте
    # self.print_job_ids = [] if self.print_job_ids.nil?
    # self.print_job_ids << job.id
    # update printed: true
    save
  end

  def cancel_print
    if print_job_ids.present?
      print_job_ids.each do |job_id|
        CupsJob.new(job_id, printer).cancel
      end
    end
  end
end
