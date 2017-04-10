class V1::OrdersController < V1::BaseController
  def create
    puts "order_params #{order_params.as_json}"
    puts "order_items_params #{order_items_params.as_json}"
  end
  
  private
  
  def order_params
    params.require(:order)
  end

  def order_items_params
    params.permit(orderItems: [:qty, :tech_card_id, techCard: [:id, :title, :price]])
  end
end
