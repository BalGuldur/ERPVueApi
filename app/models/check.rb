class Check < ApplicationRecord
  include FrontViewSecond
  has_many :check_items, dependent: :destroy
  belongs_to :cash_box
  belongs_to :order
  belongs_to :shift, required: false

  serialize :print_job_ids

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        { model: 'check_items', type: 'many', rev_type: 'one', index_inc: true },
    ]
  end

  def paid
    if paidOn.nil?
      transaction do
        check_items.each &:fix_store
        self.paidOn = DateTime.now
        save!
        # TODO: Посмотреть что сделать с change_cash
        # cash_box.change_cash summ, id
        # Выбираем открытый рабочий день или создаем новый
        @work_day = WorkDay.active_or_new
        # @work_day = WorkDay.where(closeOn: nil).last
        # @work_day = WorkDay.new(openOn: DateTime.now) if !@work_day.present?
        # Выбираем открыую смену или создаем новую
        @shift = @work_day.active_shift_or_new
        # @shift = @work_day.shifts.where(closeOn: nil).last
        # @shift = Shift.new(work_day: @work_day, openOn: DateTime.now) if !@shift.present?
        @work_day.save!
        @shift.save!
        self.shift = @shift
        save!
        # TODO: Посмотреть что сделать с fix_cat_analitic
        # check_items.each &:fix_cat_analitic
      end
    end
  end

  def summ_without_disc
    result = 0
    check_items.each {|checkItem| result += checkItem.techCardPrice * checkItem.qty}
    result
  end

  def file_name
    return "#{id}-#{DateTime.now}-check.pdf"
  end

  def printer
    CupsPrinter.new(CupsPrinter.get_all_printer_names.first)
  end

  # Высота бумаги распечатаемого чека (используется в контроллере checks print)
  def height_page
    # Генерирация высоты чека
    header_size = 20
    footer_size = 40
    order_size = self.check_items.count * 20
    page_height = header_size + footer_size + order_size
    # Если высота чека меньше ширины выставляем высоту больше, для получения landscape ориентации
    page_height = 82 if page_height < 82
    return page_height
  end

  # Печать чека
  def print file_name
    job = printer.print_file 'public/checks/' + file_name
    # Для избежания ошибки операции << на nil объекте
    self.print_job_ids = [] if self.print_job_ids.nil?
    self.print_job_ids << job.id
    update printed: true
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
