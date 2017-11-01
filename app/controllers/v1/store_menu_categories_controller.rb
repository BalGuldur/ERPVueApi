class V1::StoreMenuCategoriesController < V1::BaseController
  before_action :set_store_menu_category, only: [:destroy, :update, :tech_cards]

  def index
    @store_menu_categories = StoreMenuCategory.all
    render json: @store_menu_categories.front_view, status: :ok
  end

  def hookah_tech_card_ids
    # TODO: Сделать настраиваемым полем
    @store_menu_categories = StoreMenuCategory.where(title: 'Кальян')
    if !@store_menu_categories.empty?
      result = TechCard.includes(:store_menu_categories)
                   .where(store_menu_categories: {id: @store_menu_categories.ids}).ids
      render json: result, status: :ok
    else
      render json: nil, status: 404
    end
  end

  def create
    @store_menu_category = StoreMenuCategory.new(store_menu_category_params)
    if @store_menu_category.save
      render json: @store_menu_category.front_view, status: :ok
    else
      render json: @store_menu_category.errors, status: 404
    end
  end

  def destroy
    if @store_menu_category.destroy
      render json: @store_menu_category.front_view, status: :ok
    else
      render json: @store_menu_category.errors, status: 404
    end
  end

  def update
    if @store_menu_category.update(store_menu_category_params)
      render json: @store_menu_category.front_view, status: :ok
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
