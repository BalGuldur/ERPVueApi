class V1::InventoriesController < V1::BaseController
  before_action :set_inventory, only: [:destroy, :done]

  def index
    @inventories = Inventory.all
    render json: @inventories.front_view
    # @inventories = {} if @inventories.empty?
    # @inventory_items = InventoryItem.all.front_view
    # @inventory_items = {} if @inventory_items.empty?
    # render json: {inventories: @inventories, inventoryItems: @inventory_items}, status: :ok
  end

  def create
    @inventory = Inventory.new(inventory_params)
    # puts("params #{items_params[:inventoryItems]}")
    # params[:inventoryItems].each do |key, inventItem|
    items_params[:inventoryItems].each do |key, inventItem|
      puts("item params key #{key}, inventItem #{inventItem.as_json}")
      @inventory.inventory_items << InventoryItem.new(inventItem)
    end
    if @inventory.save
      # render json: {
      #   inventories: @inventory.front_view_with_key,
      #   inventoryItems: @inventory.inventory_items.front_view
      # }, status: :ok
      render json: @inventory.front_view
    else
      render json: @inventory.errors, status: 400
    end
  end

  def destroy
    if @inventory.destroy
      render json: @inventory.front_view, status: :ok
    else
      render json: @inventory.errors, status: 400
    end
  end

  def done
    if @inventory.done
      render json: @inventory.front_view, status: :ok
    else
      render json: @inventory.errors, status: 400
    end
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:doDate, :status)
  end

  def items_params
    params.permit(inventoryItems: [:store_item_id, :ingredient_id, :qty, :diffQty, :storeQty, :diffSumm1])
  end
end
