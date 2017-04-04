class V1::SuppliesController < V1::BaseController
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
        store_items: @supply.store_items.front_view,
        ingredients: @supply.ingredients.front_view
      }, status: :ok
    else
      render json: @supply.errors, status: 400
    end
  end

  private

  def supply_params
    params.require(:supply).permit(:supplyDate)
  end

  def items_params
    params.permit(supplyItems: [:qty, :summ, :ingredient_id])
  end
end
