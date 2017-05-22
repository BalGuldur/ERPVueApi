class V1::ShiftsController < V1::BaseController
  before_action :set_shift, only: [:close]

  def index_active
    @work_day = WorkDay.active
    if !@work_day.present?
      render json: @work_day.shifts.front_view_with_name_key, status: :ok
    else
      render json: nil, status: :ok
    end
  end

  def index
    @shifts = Shift.all
    render json: @shifts.front_view_with_name_key, status: :ok
  end

  def close
    if @shift.close close_params[:employee], close_params[:cashBoxes]
      render json: @shift.front_view_with_name_key, status: :ok
    else
      render json: @shift.errors, status: 400
    end
  end

  def print
  #   TODO: написать контроллер для печати
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def close_params
    params.permit(:employee, :cashBoxes)
  end
end
