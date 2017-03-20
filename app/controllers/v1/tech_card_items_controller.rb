class V1::TechCardItemsController < V1::BaseController
  def index
    @tech_card_items = TechCardItem.all.front_view
    @tech_card_items = {} if @tech_card_items.empty?
    render json: @tech_card_items, status: :ok
  end
end
