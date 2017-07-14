class V1::OrdersController < V1::BaseController
  before_action :set_order, only: [:destroy, :update]

  def index
    @ords = Order.not_paid
    @orders = @ords.front_view_with_name_key
    @orders = {orders: {}} if @orders.empty?
    @orderItems = OrderItem.where(order_id: @ords.ids).front_view_with_name_key
    @orderItems = {orderItems: {}} if @orderItems.empty?
    result = {}.merge!(@orders).merge!(@orderItems)
    render json: result, status: :ok
  end

  def create
    @order = Order.new(order_params)
    items_params[:orderItems].each do |key, orderItem|
      @order_item = OrderItem.new(orderItem)
      @order.order_items << OrderItem.new(orderItem)
    end
    if @order.save
      result = {}.merge!(@order.front_view_with_name_key).merge!(@order.order_items.front_view_with_name_key)
      render json: result, status: :ok
    else
      redner json: @order.errors, status: 400
    end
  end

  def destroy
    if @order.destroy
      render json: @order.front_view, status: :ok
    else
      render json: @order.errors, status: 400
    end
  end

  def update
    delete_ids = []
    old_items_params[:orderOldItems].each do |key, item|
      delete_ids = item[:id] if item[:deleted]
    end
    @delete_order_items = OrderItem.find(delete_ids)
    @order.order_items.delete(@delete_order_items)
    items_params[:orderItems].each do |key, orderItem|
      # puts "orderItem #{orderItem.as_json}"
      @order_item = OrderItem.new(orderItem)
      @order.order_items << OrderItem.new(orderItem)
    end
    @order.client = order_params[:client] if order_params[:client].present?
    @order.placeTitle = order_params[:placeTitle] if order_params[:placeTitle].present?
    if @order.save
      result = {}.merge!(@order.front_view_with_name_key).merge!(@order.order_items.front_view_with_name_key)
      render json: result, status: :ok
    else
      redner json: @order.errors, status: 400
    end
  end
  
  private

  def set_order
    @order = Order.find(params[:id])
  end
  
  def order_params
    params.require(:order).permit(:placeTitle, :client)
  end

  def items_params
    params.permit(orderItems: [:qty, :tech_card_id])
  end

  def old_items_params
    params.permit(orderOldItems: [:id, :deleted])
  end
end
