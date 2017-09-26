class V1::MenuCategoriesController < V1::BaseController
  before_action :set_menu_category, only: [:destroy]

  def index
    @menu_categories = MenuCategory.all
    render json: @menu_categories.front_view(with_child: false), status: :ok
  end

  def create
    @menu_category = MenuCategory.new(menu_category_params)
    if @menu_category.save
      render json: @menu_category.front_view_with_parent, status: :ok
    else
      render json: @menu_category.errors
    end
  end

  def destroy
    if @menu_category.destroy
      render json: @menu_category.front_view, status: :ok
    else
      render json: @menu_category.errors, status: 400
    end
  end

  private

  def set_menu_category
    @menu_category = MenuCategory.find(params[:id])
  end

  def menu_category_params
    params.permit(:title, :parent_category_id)
  end
end
