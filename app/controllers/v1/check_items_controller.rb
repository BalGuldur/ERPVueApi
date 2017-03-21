class V1::CheckItemsController < V1::BaseController
  def index
    @check_items = CheckItem.all.front_view
    @check_items = {} if @check_items.empty?
    render json: @check_items, status: :ok
  end
end
