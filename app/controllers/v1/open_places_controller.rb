# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для ОткрытыхСтолов
class V1::OpenPlacesController < V1::BaseController
  before_action :set_date, only: [:index]
  before_action :set_open_place, only: [:close, :update]

  def index
    # TODO: Посмотреть нужно ли closeTime, т.к. открытый стол мы удаляем при закрытии
    @open_places = OpenPlace.where(closeTime: nil).all
    @open_places = @open_places.where('"openTime" >= ? AND "openTime" <= ?', @date.beginning_of_day, @date.end_of_day) if @date.present?
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

  def update
    @old_places = @open_place.place_ids
    puts @old_places.as_json
    @open_place.attributes = open_place_params
    if @open_place.save
      puts @old_places.as_json
      fv_places = Place.where(id: @old_places).front_view
      fv_places[:places].merge!(@open_place.places.front_view[:places])
      render json: @open_place.front_view.merge!(fv_places),
             status: :ok
    else
      render json: @open_place.errors, status: 400
    end
  end

  private

  def set_date
    if params.permit(:date)[:date].present?
      @date = params.permit(:date)[:date].to_datetime
    end
  end

  def set_open_place
    @open_place = OpenPlace.find(params[:id])
  end

  def open_place_params
    params.require(:open_place).permit(:name, :phone, :countGuests, place_ids: [])
  end
end
