class V1::TechCardsController < V1::BaseController
  before_filter :set_tech_card, only: [:destroy, :update]

  def index
    @tech_cards = TechCard.all.front_view
    @tech_cards = {} if @tech_cards.empty?
    render json: @tech_cards, status: :ok
  end

  def create
    puts "params #{params.as_json}"
    puts "tech card params #{tech_card_params.as_json}"
    puts "tech card items params #{tech_card_items_params.as_json}"
    @tech_card = TechCard.create(tech_card_params)
    items = tech_card_items_params[:items]
    @tech_card_items = []
    items.each do |item|
      if item[:qty].present? and item[:ingredient][:id].present?
        @tech_card_items << TechCardItem.create(qty: item[:qty], ingredient_id: item[:ingredient][:id], tech_card: @tech_card)
      end
    end
    render json: {tech_card: @tech_card, tech_card_items: @tech_card_items}
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
end
