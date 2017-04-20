class V1::SuppliesController < V1::BaseController
  before_action :set_supply, only: [:revert, :perform]

  def index
    @supplies = Supply.all.front_view_with_name_key
    @supplies = {supplies: {}} if @supplies.empty?
    @supplyItems = SupplyItem.all.front_view_with_name_key
    @supplyItems = {supplyItems: {}} if @supplyItems.empty?
    result = {}.merge!(@supplies).merge!(@supplyItems)
    render json: result, status: :ok
  end

  def create
    puts "supply_params #{supply_params.as_json}"
    puts "items_params #{items_params.as_json}"
    @supply = Supply.new(supply_params)
    items_params[:supplyItems].each do |supply_item|
      puts "supply_item #{supply_item.as_json}"
      @supply.supply_items << SupplyItem.new(supply_item)
    end
    if @supply.save
      render json: {
        supplies: @supply.front_view_with_key,
        supplyItems: @supply.supply_items.front_view,
        store_items: @supply.store_items.front_view,
        ingredients: @supply.ingredients.front_view
      }, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  def revert
    if @supply.revert
      render json: {
        supplies: @supply.front_view_with_key,
        store_items: @supply.store_items.front_view
      }, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  def perform
    if @supply.perform
      render json: {
        supplies: @supply.front_view_with_key,
        store_items: @supply.store_items.front_view
      }, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  private

  def set_supply
    @supply = Supply.find(params[:id])
  end

  def supply_params
    params.require(:supply).permit(:supplyDate, :summ, :caterer, :performed)
  end

  def items_params
    params.permit(supplyItems: [:qty, :summ, :ingredient_id])
  end
end
