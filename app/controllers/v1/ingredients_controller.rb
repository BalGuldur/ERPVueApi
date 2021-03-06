class V1::IngredientsController < V1::BaseController
  before_action :set_ingredient, only: [:destroy, :add_category, :remove_category]
  before_action :set_category, only: [:remove_category]
  before_action :set_or_create_category, only: [:add_category]

  def index
    @ingredients = Ingredient.all
    # @ingredients = {} if @ingredients.empty?
    # render json: @ingredients, status: :ok
    render json: @ingredients.front_view, status: :ok
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    @store_item = StoreItem.new(ingredient: @ingredient, remains: 0, price: start_price)
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
    unless @ingredient.store_menu_categories.find_by(title: @store_menu_category.title).present?
      @ingredient.store_menu_categories << @store_menu_category
    end
    if @ingredient.save
      render json: @ingredient.front_view, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  def remove_category
    if @ingredient.store_menu_categories.delete(@store_menu_category)
      render json: @ingredient.front_view, status: :ok
    else
      render json: @ingredient.errors, status: 404
    end
  end

  private

  def ingredient_params
    params.permit(:title, :measure, :store_menu_category_ids)
  end

  def start_price
    params[:start_price].present? ? params[:start_price] : nil
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def set_or_create_category
    @store_menu_category = StoreMenuCategory.find_by(title: params[:category][:title])
    @store_menu_category = StoreMenuCategory.create(title: params[:category][:title]) unless @store_menu_category.present?
  end

  def set_category
    @store_menu_category = StoreMenuCategory.find(params[:category][:id])
  end
end
