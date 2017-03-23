class V1::TechCardsController < V1::BaseController
  before_filter :set_tech_card, only: [:destroy, :update]
  before_action :set_category, only: [:add_category, :remove_category]

  def index
    @tech_cards = TechCard.all.front_view
    @tech_cards = {} if @tech_cards.empty?
    render json: @tech_cards, status: :ok
  end

  def create
    @tech_card = TechCard.new(tech_card_params)
    items = tech_card_items_params[:items]
    items.each do |item|
      @new_item = TechCardItem.new(qty: item[:qty], ingredient_id: item[:ingredient][:id])
      @tech_card.tech_card_items << @new_item
    end
    if @tech_card.save
      render json: {tech_card: @tech_card.front_view, tech_card_items: @tech_card.tech_card_items.all.front_view}, status: :ok
    else
      render json: @tech_card.errors, status: 400
    end
  end

  def update
    items = tech_card_items_params[:items]
    @tech_card_items = []
    @tech_card.tech_card_items.destroy_all
    items.each do |item|
      if item[:qty].present? and item[:ingredient][:id].present?
        @tech_card_items << TechCardItem.create(qty: item[:qty], ingredient_id: item[:ingredient][:id], tech_card: @tech_card)
      end
    end
    @tech_card.update(tech_card_params)
    render json: {tech_card: @tech_card, tech_card_items: @tech_card_items}
  end

  def destroy
    @tech_card.tech_card_items.destroy_all
    if @tech_card.destroy
      render json: @tech_card, status: :ok
    else
      render json: @tech_card.errors, status: 404
    end
  end

  def add_category
    @tech_card.store_menu_categories << @store_menu_category
    if @tech_card.save
      render json: {tech_card: @tech_card.front_view}, status: :ok
    else
      render json: @tech_card.errors, status: 404
    end
  end

  def remove_category
    if @tech_card.store_menu_categories.delete(@store_menu_category)
      render json: @tech_card.front_view, status: :ok
    else
      render json: @tech_card.errors, status: 404
    end
  end

  private

  def tech_card_params
    params.permit(:price, :title)
  end

  def tech_card_items_params
    params.permit(:items => [:qty, :ingredient => [:id]])
  end

  def set_tech_card
    @tech_card = TechCard.find(params[:id])
  end

  def set_category
    puts "params #{params.as_json}"
    @store_menu_category = StoreMenuCategory.find(params[:category][:id])
  end
end
