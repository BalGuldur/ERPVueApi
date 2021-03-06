class V1::StoreItemsController < V1::BaseController
  before_action :set_store_item, only: [:destroy, :update]

  def index
    @store_items = StoreItem.all
    render json: @store_items.front_view(:without_child), status: :ok
  end

  def create
    @store_item = StoreItem.add_supply(store_item_params)
    if @store_item.save
      render json: @store_item, status: :ok
    else
      render json: @store_item.errors, status: 404
    end
  end

  def update
    @store_item.attributes = store_item_params
    if @store_item.save
      render json: @store_item.front_view
    else
      render json: @store_item.errors, status: 404
    end
  end

  def destroy
    if @store_item.destroy
      render json: @store_item, status: :ok
    else
      render json: @store_item.errors, status: 404
    end
  end

  private

  def store_item_params
    params.permit(:price, :remains, :ingredient_id)
  end

  def set_store_item
    @store_item = StoreItem.find(params[:id])
  end
end
