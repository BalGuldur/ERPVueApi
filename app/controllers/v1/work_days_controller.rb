class V1::WorkDaysController < V1::BaseController
  before_action :set_work_day, only: [:shifts, :print]

  def index
    @work_days = WorkDay.all
    render json: @work_days.front_view_with_name_key, status: :ok
  end

  def index_active
    @work_day = WorkDay.active
    if @work_day.present?
      render json: @work_day.front_view, status: :ok
    else
      render json: {workDays: nil}, status: :ok
    end
  end

  def shifts
    if @work_day.present?
      render json: @work_day.shifts.front_view, status: :ok
    else
      render json: @work_day, status: 400
    end
  end

  def close
    @work_day = WorkDay.close
    if @work_day.present?
      render json: @work_day.front_view, status: :ok
    else
      render json: @work_day.errors, status: 400
    end
  end

  def print
    # Генерируем имя файла (нужно сделать отдельно, т.к. вызывается в двух местах)
    file_name = @work_day.file_name
    @filter_cat = ['Кухня', 'Бар', 'Кальян']
    @st_men_cat_ans = @work_day.store_menu_cat_analitics.includes(:store_menu_category).where(store_menu_categories: {title: @filter_cat})
    @qty = @st_men_cat_ans.group(:title).sum(:qty)
    @summ = @st_men_cat_ans.group(:title).sum(:summ)
    @cash_box_ans = @work_day.cash_box_analitics.includes(:cash_box)
    @realCash = @cash_box_ans.group(:title).sum(:realCash)
    @purchaseSumm = @cash_box_ans.group(:title).sum(:purchaseSumm)
    @cash = @cash_box_ans.group(:title).sum(:cash)
    @cash_boxes = CashBox.order(:id).pluck(:title)
    # @cash_box_analitics = @shift
    # Генерируем файл с чеком
    render :pdf => 'print_change_cash_box',
           margin: {top: 8, bottom: 8, left: 8, right: 8},
           page_height: @work_day.height_page,
           page_width: 80,
           encoding: 'utf8',
           save_only: true,
           save_to_file: Rails.root.join('public/workDays', file_name)
    # Печатаем сгенерированный файл
    @work_day.print(file_name)
    # render json: '', status: :ok
  end

  private

  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end
end
