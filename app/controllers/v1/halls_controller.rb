# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для залов
class V1::HallsController < V1::BaseController
  before_action :set_hall, only: [:destroy, :update]

  def index
    @halls = Hall.all
    render json: @halls.front_view, status: :ok
  end

  def create
    @hall = Hall.new(hall_params)
    if @hall.save
      render json: @hall.front_view, status: :ok
    else
      render json: @hall.errors, status: 400
    end
  end

  def destroy
    if @hall.destroy
      render json: @hall.front_view, status: :ok
    else
      render json: @hall.errors, status: 400
    end
  end

  def update
    @hall.attributes = hall_params
    if @hall.save
      render json: @hall.front_view, status: :ok
    else
      render json: @hall.errors, status: 400
    end
  end

  private

  def hall_params
    params.require(:hall).permit(:title)
  end

  def set_hall
    @hall = Hall.find(params[:id])
  end
end
