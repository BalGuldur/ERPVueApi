class V1::CashBoxesController < V1::BaseController
  before_action :set_cash_box, only: [:destroy, :update]

  def index
    @cash_boxes = CashBox.all.front_view
    @cash_boxes = {} if @cash_boxes.empty?
    render json: @cash_boxes, status: :ok
  end

  def create
    @cash_box = CashBox.new(cash_box_params)
    if @cash_box.save
      render json: @cash_box, status: :ok
    else
      render json: @cash_box.errors, status: 404
    end
  end

  def destroy
    if @cash_box.destroy
      render json: @cash_box, status: :ok
    else
      render json: @cash_box.errors, status: 404
    end
  end

  def update
    if @cash_box.update(cash_box_params)
      render json: @cash_box, status: :ok
    else
      render json: @cash_box.errors, status: 404
    end
  end

  private

  def cash_box_params
    params.permit(:title, :discount)
  end

  def set_cash_box
    @cash_box = CashBox.find(params[:id])
  end
end
