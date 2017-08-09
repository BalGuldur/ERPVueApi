# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для залов
class V1::PlacesController < V1::BaseController
  before_action :set_place, only: [:update, :destroy]

  def create
    @place = Place.new(place_params)
    if @place.save
      render json: @place.hall.front_view, status: :ok
    else
      render json: @place.errors, status: 400
    end
  end

  def update
    @place.attributes = place_params
    if @place.save
      # рендериться только стол, учесть если будет меняться hall_id через этот экшен
      render json: @place.front_view, status: :ok
    else
      render json: @place.errors, status: 400
    end
  end

  def destroy
    if @place.destroy
      render json: @place.front_view, status: :ok
    else
      render json: @place.errors, status: 400
    end
  end

  private

  def place_params
    params.require(:place).permit(:title, :capacity, :hall_id)
  end

  def set_place
    @place = Place.find(params[:id])
  end
end
