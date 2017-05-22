class V1::WorkDaysController < V1::BaseController
  before_action :set_work_day, only: [:shifts]

  def index
    @work_days = WorkDay.all
    render json: @work_days.front_view_with_name_key, status: :ok
  end

  def index_active
    @work_day = WorkDay.active
    if @work_day.present?
      render json: @work_day.front_view_with_name_key, status: :ok
    else
      render json: @work_day, status: 400
    end
  end

  def shifts
    if @work_day.present?
      render json: @work_day.shifts.front_view_with_name_key, status: :ok
    else
      render json: @work_day, status: 400
    end
  end

  def close
    @work_day = WorkDay.close
    if @work_day.present?
      render json: @work_day.front_view_with_name_key, status: :ok
    else
      render json: @work_day.errors, status: 400
    end
  end

  private

  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end
end
