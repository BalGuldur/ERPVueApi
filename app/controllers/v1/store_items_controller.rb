class V1::StoreItemsController < V1::BaseController
  before_action :set_store_item, only: [:destroy]

  def index
    @store_items = StoreItem.all.front_view
    @store_items = {} if @store_items.empty?
    render json: @store_items, status: :ok
  end

  def create
    # ingredient = Ingredient.find(params[:ingredient_id])
    # price = params[:price]
    # remains = params[:remains]
    #
    # if ingredient.store_item.present?
    #   old_store_item = ingredient.store_item
    #   old_store_item.price = ((old_store_item.price * old_store_item.remains) + price) / (old_store_item.remains + remains)
    #   old_store_item.remains = old_store_item.remains + remains
    #   @store_item = old_store_item
    # else
    #   @store_item = StoreItem.new(ingredient: ingredient, price: price / remains, remains: remains)
    # end
    @store_item = StoreItem.add_supply(store_item_params)
    if @store_item.save
      render json: @store_item, status: :ok
    else
      render json: @store_itme, status: 404
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
