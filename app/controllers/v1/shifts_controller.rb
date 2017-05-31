class V1::ShiftsController < V1::BaseController
  before_action :set_shift, only: [:close, :print]

  def index_active
    @work_day = WorkDay.active
    if @work_day.present?
      @shifts = @work_day.shifts
      result = @shifts.front_view_with_name_key
      result.merge! CashBoxAnalitic.where(shift: @shifts).front_view_with_name_key
      result.merge! StoreMenuCatAnalitic.where(shift: @shifts).front_view_with_name_key
      render json: result.as_json, status: :ok
    else
      render json: nil, status: :ok
    end
  end

  def index
    @shifts = Shift.all
    render json: @shifts.front_view_with_name_key, status: :ok
  end

  def close
    if @shift.close close_params[:employee],
                    close_params[:cashBoxes]
      @shifts = Shift.where(id: @shift.id)
      result = @shifts.front_view_with_name_key
      result.merge! CashBoxAnalitic.where(shift: @shifts).front_view_with_name_key
      result.merge! StoreMenuCatAnalitic.where(shift: @shifts).front_view_with_name_key
      render json: result.as_json, status: :ok
    else
      render json: @shift.errors, status: 400
    end
  end

  def print
    # Генерируем имя файла (нужно сделать отдельно, т.к. вызывается в двух местах)
    file_name = @shift.file_name
    @filter_cat = ['Кухня', 'Бар', 'Кальян']
    @st_men_cat_ans = @shift.store_menu_cat_analitics.includes(:store_menu_category).where(store_menu_categories: {title: @filter_cat})
    @qty = @st_men_cat_ans.group(:title).sum(:qty)
    @summ = @st_men_cat_ans.group(:title).sum(:summ)
    @cash_box_ans = @shift.cash_box_analitics.order(:cash_box_id)
    # @cash_box_analitics = @shift
    # Генерируем файл с чеком
    render :pdf => 'print_change_cash_box',
           margin: {top: 8, bottom: 8, left: 8, right: 8},
           page_height: @shift.height_page,
           page_width: 80,
           encoding: 'utf8',
           save_only: true,
           save_to_file: Rails.root.join('public/shifts', file_name)
    # Печатаем сгенерированный файл
    @shift.print(file_name)
    # render json: '', status: :ok
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def close_params
    params.permit(:employee, cashBoxes: [:id, :title, :realCash, :purchaseSumm])
  end
end
