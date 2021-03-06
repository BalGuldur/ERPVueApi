# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для БронейСтолов
class V1::BookingPlacesController < V1::BaseController
  before_action :set_date, only: [:index]
  before_action :set_booking_place, only: [:close, :update, :show, :open]

  def index
    # TODO: Выборка бронирования по дате
    @booking_places = if @date.nil?
                        BookingPlace.all
                      else
                        BookingPlace.where('"openTime" >= ? AND "openTime" <= ?', @date.beginning_of_day + 7.hours, @date.end_of_day + 7.hours)
                      end
    render json: @booking_places.front_view(with_child: false), status: :ok
  end

  def show
    if @booking_place.present?
      render json: @booking_place.front_view(without_id: true), status: :ok
    else
      render json: nil, status: 400
    end
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

  def open
    if @booking_place.open
      render json: @booking_place.front_view, status: :ok
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
    @old_places = @booking_place.place_ids
    @booking_place.attributes = booking_place_params
    if @booking_place.save
      # render json: @booking_place.front_view.merge!(@booking_place.places.front_view),
      #        status: :ok
      fv_old_places = Place.where(id: @old_places).front_view(with_child: false)
      fv_places = @booking_place.front_view
      fv_places = {places: fv_places['places'].merge!(fv_old_places['places'])}
      fv = @booking_place.front_view.merge! fv_places
      render json: fv, status: :ok
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
