# rubocop:disable Style/AsciiComments
# rubocop:disable Style/ClassAndModuleChildren
# Обработка списаний со склада
class V1::WastesController < V1::BaseController
  before_action :set_waste, only: [:revert]

  def index
    @wastes = Waste.all
    render json: @wastes.front_view, status: :ok
    # @wastes = Waste.all.front_view_with_name_key
    # @wastes = {wastes: {}} if @wastes.empty?
    # @waste_items = WasteItem.all.front_view_with_name_key
    # @waste_items = {wasteItems: {}} if @waste_items.empty?
    # result = {}.merge!(@wastes).merge!(@waste_items)
    # render json: result, status: :ok
  end

  def create
    @waste = Waste.new(waste_params)
    items_params[:wasteItems].each do |wasteItem|
      puts("item params, wasteItem #{wasteItem.as_json}")
      @waste.waste_items << WasteItem.new(wasteItem)
    end
    if @waste.save
      @waste.waste_store
      result = {}.merge!(wastes: @waste.front_view_with_key).merge!(@waste.waste_items.front_view_with_name_key)
      render json: result, status: :ok
    else
      render json: @waste.errors, status: 400
    end
  end

  def revert
    if @waste.revert
      render json: @waste, status: :ok
    else
      render json: @waste.errors, status: 400
    end
  end

  private

  def set_waste
    @waste = Waste.find(params[:id])
  end

  def waste_params
    params.require(:waste).permit(:summ)
  end

  def items_params
    params.permit(wasteItems: [:ingredient_id, :store_item_id, :qty, :storeItemPrice, :ingMeasure, :price, :storeItemPrice])
  end
end
