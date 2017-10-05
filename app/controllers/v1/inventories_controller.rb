class V1::InventoriesController < V1::BaseController
  before_action :set_inventory, only: [:destroy]
  before_action :set_or_new_inventory, only: [:later, :done]

  def index
    @inventories = Inventory.all
    render json: @inventories.front_view
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

  def later
    if @inventory.later(inventory_params, items_params)
      render json: @inventory.front_view, status: :ok
    else
      render json: @inventory.errors, status: 400
    end
  end

  def done
    if @inventory.done(inventory_params, items_params)
      render json: @inventory.front_view.merge!(StoreItem.front_view), status: :ok
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

  private

  def set_or_new_inventory
    @inventory = if inventory_params[:id] < 1
                   Inventory.new
                 else
                   Inventory.find(inventory_params[:id])
                 end
  end

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:doDate, :id)
  end

  def items_params
    keys = {}
    item_keys = [:store_item_id, :ingredient_id, :qty, :diffQty, :storeQty, :diffSumm]
    params[:inventoryItems].keys.each {|key| keys.merge!({key => item_keys})}
    params.require(:inventoryItems).permit(keys)
  end
end
