class V1::ChecksController < V1::BaseController
  before_action :set_check, only: [:destroy]

  def index
    @checks = Check.all.front_view
    @checks = {} if @checks.empty?
    render json: @checks, status: :ok
  end

  def create
    # puts "check_params #{check_params.as_json}"
    # puts "check_items_params #{check_items_params.as_json}"
    @check = Check.new(check_params)
    check_items_params[:check_items].each do |check_item_param|
      @check_item = CheckItem.new(check_item_param)
      @check.check_items << @check_item
    end
    if @check.save
      render json: { check: @check.front_view, check_items: @check.check_items.all.front_view }, status: :ok
    else
      render json: @check.errors, status: 400
    end
  end

  def destroy
    if @check.destroy
      render json: @check.front_view, status: :ok
    else
      render json: @check.errors, status: 400
    end
  end

  private

  def set_check
    @check = Check.find(params[:id])
  end

  def check_params
    # TODO: Подумать о параметрах, может передавать только id в cash_box
    params.require(:check).permit(:client, :summ, :cash_box_id, :cash_box_title, :cash_box_discount, :paidOn)
  end

  def check_items_params
    # TODO: Подумать о параметрах, может передавать только id в tech_card
    params.permit(check_items: [:discount, :qty, :tech_card_id, :tech_card_price, :tech_card_title, :amount_paid])
  end
end
