class V1::StoreMenuCategoriesController < V1::BaseController
  before_action :set_store_menu_category, only: [:destroy, :update]

  def index
    @store_menu_categories = StoreMenuCategory.all.front_view
    @store_menu_categories = {} if @store_menu_categories.empty?
    render json: @store_menu_categories, status: :ok
  end

  def create
    @store_menu_category = StoreMenuCategory.new(store_menu_category_params)
    if @store_menu_category.save
      render json: @store_menu_category, status: :ok
    else
      render json: @store_menu_category.errors, status: 404
    end
  end

  def destroy
    if @store_menu_category.destroy
      render json: @store_menu_category, status: :ok
    else
      render json: @store_menu_category.errors, status: 404
    end
  end

  def update
    if @store_menu_category.update(store_menu_category_params)
      render json: @store_menu_category, status: :ok
    else
      render json: @store_menu_category.errors, status: 404
    end
  end

  private

  def store_menu_category_params
    params.permit(:title)
  end

  def set_store_menu_category
    @store_menu_category = StoreMenuCategory.find(params[:id])
  end
end
