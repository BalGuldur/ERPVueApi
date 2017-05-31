class V1::EncashController < V1::BaseController
  before_action :set_cash_box, only: [:create]
  before_action :set_amount, only: [:create]

  def create
    @encash = Encash.first || Encash.new
    if @encash.encashing @cash_box, @amount
      render json: {cashBoxes: nil, encash: @encash}, status: :ok
    else
      render json: @encash.errors, status: 400
    end
  end

  private

  def set_cash_box
    @cash_box = CashBox.find(params[:encash][:cash_box_id])
  end

  def set_amount
    @amount = params[:encash][:amount]
  end
end
