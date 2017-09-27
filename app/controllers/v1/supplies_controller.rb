class V1::SuppliesController < V1::BaseController
  before_action :set_supply, only: [:revert, :perform]

  def index
    @supplies = Supply.all
    # @supplies = {supplies: {}} if @supplies.empty?
    # @supplyItems = SupplyItem.all.front_view_with_name_key
    # @supplyItems = {supplyItems: {}} if @supplyItems.empty?
    # result = {}.merge!(@supplies).merge!(@supplyItems)
    # render json: result, status: :ok
    # TODO: Посмотреть как упростить выгрузку front_view
    # res = @supplies.front_view
    # res.merge! Ingredient.all.front_view(with_child: false)
    # res.merge! StoreItem.all.front_view(with_child: false)
    # @supply_items = SupplyItem.includes(:supply).where(supplies: {id: @supplies.ids})
    # # res.merge!(Ingredient.includes(:supply_items).where(supply_items: {id: @supply_items.ids}).front_view)
    render json: @supplies.front_view, status: :ok
  end

  def create
    @supply = Supply.new(supply_params)
    items_params[:supplyItems].each do |supply_item|
      @supply.supply_items << SupplyItem.new(supply_item)
    end
    if @supply.save
      res = @supply.front_view
      res.merge!(@supply.store_items.front_view(with_child: false))
      res.merge!(@supply.ingredients.front_view(with_child: false))
      render json: res, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  def revert
    if @supply.revert
      render json: @supply.front_view, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  def perform
    if @supply.perform
      # render json: {
      #   supplies: @supply.front_view_with_key,
      #   store_items: @supply.store_items.front_view
      # }, status: :ok
      render json: @supply.front_view, status: :ok
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
