# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка вызовов для ОткрытыхСтолов
class V1::OpenPlacesController < V1::BaseController
  before_action :set_date, only: [:index]
  before_action :set_open_place, only: [:close, :update, :add_order, :add_or_create_order, :add_hookah_order]

  def index
    # TODO: Посмотреть нужно ли closeTime, т.к. открытый стол мы удаляем при закрытии
    @open_places = OpenPlace.where(id: OpenPlace.where(closeTime: nil).ids)
    @open_places = @open_places.where('"openTime" >= ? AND "openTime" <= ?', @date.beginning_of_day + 7.hours, @date.end_of_day + 7.hours) if @date.present?
    render json: @open_places.front_view(with_child: false), status: :ok
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

  def add_hookah_order
    puts hookah_order_items_params.as_json
    if @open_place.add_hookah_order(hookah_order_items_params[:items])
      render json: @open_place.orders.last.front_view, status: :ok
    else
      render json: @open_place.errors, status: 400
    end
  end

  def add_order
    if @open_place.create_empty_order
      render json: @open_place.front_view, status: :ok
    else
      render json: @open_place.errors, status: 400
    end
  end

  def add_or_create_order
    if @open_place.add_or_create_order
      render json: @open_place.front_view, status: :ok
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
    # puts @old_places.as_json
    @open_place.attributes = open_place_params
    if @open_place.save
      puts @old_places.as_json
      # fv_places = Place.where(id: @old_places).front_view
      # fv_places[:places].merge!(@open_place.places.front_view[:places])
      # render json: @open_place.front_view.merge!(fv_places),
      #        status: :ok
      fv_old_places = Place.where(id: @old_places).front_view(with_child: false)
      fv_places = @open_place.front_view
      fv_places = {places: fv_places['places'].merge!(fv_old_places['places'])}
      fv = @open_place.front_view.merge! fv_places
      render json: fv, status: :ok
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

  def hookah_order_items_params
    params.permit(items: [:qty, :tech_card_id])
  end
end
