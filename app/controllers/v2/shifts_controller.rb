class V2::ShiftsController < V2::BaseController
  before_action :set_shift, only: [:close, :print]

  def index_active
    @work_day = WorkDay.active
    if @work_day.present?
      @shifts = @work_day.shifts
      result = @shifts.front_view
      result.merge! CashBoxAnalitic.where(shift: @shifts).front_view
      result.merge! StoreMenuCatAnalitic.where(shift: @shifts).front_view
      render json: result.as_json, status: :ok
    else
      render json: nil, status: :ok
    end
  end

  def close
    puts close_params.as_json
    if @shift.close_v2 close_params[:shift], close_params[:realCashes]
      render json: @shift.front_view, status: :ok
    else
      render json: @shift.errors, status: 400
    end
  end

  def print
    file_name = @shift.file_name
    @store_menu_cat_analitics = @shift.check_items.store_cat_analitic_v2(['Кухня', 'Бар', 'Кальян'])
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
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def close_params
    params.permit(
      shift: [
        :employee,
        :notPaidClientsSumm,
        :notPaidStaffSumm,
        :purchaseSumm
      ],
      realCashes: [
        :cash_box_id,
        :realCash
      ]
    )
  end
end
