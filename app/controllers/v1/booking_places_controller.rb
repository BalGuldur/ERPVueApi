# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для БронейСтолов
class V1::BookingPlacesController < V1::BaseController
  before_action :set_date, only: [:index]
  before_action :set_booking_place, only: [:close, :update]

  def index
    # TODO: Выборка бронирования по дате
    @booking_places = if @date.nil?
                        BookingPlace.all
                      else
                        BookingPlace.where('"openTime" >= ? AND "openTime" <= ?', @date.beginning_of_day, @date.end_of_day)
                      end
    render json: @booking_places.front_view, status: :ok
  end

  def create
    @booking_place = BookingPlace.new(booking_place_params)
    if @booking_place.save
      render json: @booking_place.front_view.merge!(@booking_place.places.front_view),
             status: :ok
    else
      render json: @booking_place.errors, status: 400
    end
  end

  def close
    if @booking_place.close
      render json: @booking_place.front_view.merge!(@booking_place.places.front_view),
             status: :ok
    else
      render json: @booking_place.errors, status: 400
    end
  end

  def update
    @booking_place.attributes = booking_place_params
    if @booking_place.save
      render json: @booking_place.front_view.merge!(@booking_place.places.front_view),
             status: :ok
    else
      render json: @booking_place.errors, status: 400
    end
  end

  private

  def set_date
    if params.permit(:date)[:date].present?
      @date = params.permit(:date)[:date].to_datetime
    end
  end

  def set_booking_place
    @booking_place = BookingPlace.find(params[:id])
  end

  def booking_place_params
    params.require(:booking_place).permit(:name, :phone, :countGuests,
                                          :openTime, place_ids: [])
  end
end
