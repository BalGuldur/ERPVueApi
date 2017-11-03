class V2::WorkDaysController < V2::BaseController
  before_action :set_work_day, only: [:print]

  def index_active
    @work_day = WorkDay.active
    if @work_day.present?
      render json: @work_day.front_view, status: :ok
    else
      render json: {workDays: nil}, status: :ok
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
    file_name = @work_day.file_name
    @cash_boxes = CashBox.order(:id).pluck(:title)
    @cash_box_ans = @work_day.cash_box_analitics.includes(:cash_box)
    @cash = @cash_box_ans.group(:title).sum(:cash)
    @realCash = @cash_box_ans.group(:title).sum(:realCash)
    @staffSumm = @cash_box_ans.group(:title).sum(:notPaidStaffSumm)
    @diffCash = @cash_box_ans.group(:title).sum(:diffCash)
    @store_menu_cat_analitics = @work_day.check_items.store_cat_analitic_v2(['Кухня', 'Бар', 'Кальян'])
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
  end

  private

  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end
end
