# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для залов
class V1::OpenPlacesController < V1::BaseController
  before_action :set_open_place, only: [:close]

  def index
    @open_places = OpenPlace.where(closeTime: nil).all
    render json: @open_places.front_view, status: :ok
  end

  def create
    @open_place = OpenPlace.new(open_place_params.merge!(openTime: DateTime.now))
    if @open_place.save
      render json: @open_place.front_view.merge!(@open_place.places.front_view),
             status: :ok
    else
      render json: @open_place.errors, status: 400
    end
  end

  def close
    if @open_place.close
      render json: @open_place.front_view.merge!(@open_place.places.front_view),
             status: :ok
    else
      render json: @open_place.errors, status: 400
    end
  end

  private

  def set_open_place
    @open_place = OpenPlace.find(params[:id])
  end

  def open_place_params
    params.require(:open_place).permit(:name, :phone, :countGuests, place_ids: [])
  end
end
