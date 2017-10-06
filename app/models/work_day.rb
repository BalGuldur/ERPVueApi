class WorkDay < ApplicationRecord
  include FrontViewSecond
  has_many :shifts
  has_many :store_menu_cat_analitics, through: :shifts
  has_many :cash_box_analitics, through: :shifts

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        # { model: 'tech_card', type: 'one', rev_type: 'many', index_inc: false },
        { model: 'shifts', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  def self.close
    @work_day = WorkDay.where(closeOn: nil).last
    if (@work_day.present? and !@work_day.shift_is_open)
      @work_day.close
    end
    @work_day
  end

  def self.active
    @work_day = WorkDay.where(closeOn: nil).last
    @work_day
  end

  def shift_is_open
    self.shifts.find_by(closeOn: nil).present?
  end

  def close
    transaction do
      self.closeOn = DateTime.now
      save!
    end
  end

  # Стандартный набор для генерации front_view
  def self.front_view_with_name_key
    f_v = {}
    all.each do |work_day|
      f_v.merge!(work_day.front_view_with_key)
    end
    {workDays: f_v}
  end

  # def self.front_view
  #   f_v = {}
  #   all.includes(:shifts).find_each do |work_day|
  #     f_v.merge!(work_day.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {workDays: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:shift_ids])
  # end

  def file_name
    return "#{id}-#{DateTime.now}-workDay.pdf"
  end

  # Набор для печати
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
    job = printer.print_file 'public/workDays/' + file_name
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
