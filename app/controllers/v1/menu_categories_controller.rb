class V1::MenuCategoriesController < V1::BaseController
  before_action :set_menu_category, only: [:destroy]

  def index
    @menu_categories = MenuCategory.all.front_view_with_name_key
    @menu_categories = {} if @menu_categories.empty?
    render json: @menu_categories, status: :ok
  end

  def create
    errors = []
    not_error = true
    MenuCategory.transaction do
      menu_category_params[:categories].each do |menu_cat|
        @menu_category = MenuCategory.new(menu_cat)
        @menu_category.valid?
        errors << @menu_category.errors.messages
        not_error = @menu_category.save!
      end
    end
    if not_error
      result = {}.merge!(menuCategories: @menu_category.front_view_with_key)
      result[:menuCategories].merge!(@menu_category.parent_category.front_view_with_key) if @menu_category.parent_category.present?
      render json: result, status: :ok
    else
      render json: errors, status: 400
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
    # params.require(:category).permit(:title, :parent_category_id)
    params.permit(categories: [:title, :parent_category_id])
  end
end
