class V1::IngredientsController < V1::BaseController
  before_action :set_ingredient, only: [:destroy]

  def index
    @ingredients = Ingredient.all.front_view
    @ingredients = {} if @ingredients.empty?
    render json: @ingredients, status: :ok
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    start_price.present? && @store_item = StoreItem.new(ingredient: @ingredient, remains: 0, price: start_price)
    if @ingredient.save && @store_item.save
      render json: @ingredient, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  def destroy
    if @ingredient.destroy
      render json: @ingredient, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  private

  def ingredient_params
    params.permit(:title, :measure)
  end

  def start_price
    params[:start_price].present? ? params[:start_price] : nil
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
end
