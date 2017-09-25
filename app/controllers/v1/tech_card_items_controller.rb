class V1::TechCardItemsController < V1::BaseController
  def index
    @tech_card_items = TechCardItem.all
    render json: @tech_card_items.front_view(with_child: false), status: :ok
  end
end
