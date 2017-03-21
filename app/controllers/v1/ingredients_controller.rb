class V1::IngredientsController < V1::BaseController
  before_action :set_ingredient, only: [:destroy, :add_category, :remove_category]
  before_action :set_category, only: [:add_category, :remove_category]

  def index
    @ingredients = Ingredient.all.front_view
    @ingredients = {} if @ingredients.empty?
    render json: @ingredients, status: :ok
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    start_price.present? && @store_item = StoreItem.new(ingredient: @ingredient, remains: 0, price: start_price)
    if @ingredient.save && @store_item.save
      render json: @ingredient.front_view, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  def destroy
    if @ingredient.destroy
      render json: @ingredient.front_view, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  def add_category
    @ingredient.store_menu_categories << @store_menu_category
    if @ingredient.save
      render json: {ingredient: @ingredient.front_view}, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  def remove_category
    if @ingredient.store_menu_categories.delete(@store_menu_category)
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

  def set_category
    puts "params #{params.as_json}"
    @store_menu_category = StoreMenuCategory.find(params[:category][:id])
  end
end
