class Check < ApplicationRecord
  has_many :check_items, dependent: :destroy
  belongs_to :cash_box
  belongs_to :order
  belongs_to :shift, required: false

  serialize :print_job_ids

  def self.front_view_with_name_key
    f_v = {}
    all.each do |check|
      f_v.merge!(check.front_view_with_key)
    end
    {checks: f_v}
  end

  def self.front_view
    f_v = {}
    all.each do |check|
      f_v.merge!(check.front_view_with_key)
    end
    f_v
  end

  def paid
    transaction do
      check_items.each &:fix_store
      self.paidOn = DateTime.now
      save!
      cash_box.change_cash summ
      # Выбираем открытый рабочий день или создаем новый
      @work_day = WorkDay.where(closeOn: nil).last
      @work_day = WorkDay.new(openOn: DateTime.now) if !@work_day.present?
      # Выбираем открыую смену или создаем новую
      @shift = @work_day.shifts.where(closeOn: nil).last
      @shift = Shift.new(work_day: @work_day, openOn: DateTime.now) if !@shift.present?
      @work_day.save!
      @shift.save!
      self.shift = @shift
      check_items.each &:fix_cat_analitic
    end
  end

  def front_view_with_name_key
    {checks: front_view_with_key}
  end

  def front_view_with_key
    {id => front_view}
  end

  def front_view
    as_json(methods: [:check_item_ids, :cash_box_id])
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
