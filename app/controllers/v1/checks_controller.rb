class V1::ChecksController < V1::BaseController
  before_action :set_check, only: [:destroy, :paid]
  before_action :set_order, only: [:save]

  # def index
  #   @checks = Check.all.front_view
  #   @checks = {} if @checks.empty?
  #   render json: @checks, status: :ok
  # end
  def index
    @checks = Check.where(paidOn: nil).front_view_with_name_key
    @checkItems = CheckItem.joins(:check).where(checks: {paidOn: nil}).front_view_with_name_key
    result = {}.merge!(@checks).merge!(@checkItems)
    render json: result, status: :ok
  end

  def print
    checks_params[:checks].each do |key, check|
      @check = Check.find(key)
      # Удаляем все уже запущенные задания на печать этого чека
      @check.cancel_print
      # Генерируем имя файла (нужно сделать отдельно, т.к. вызывается в двух местах)
      file_name = @check.file_name
      # Генерируем файл с чеком
      render :pdf => 'print_check',
             margin: {top: 8, bottom: 8, left: 8, right: 8},
             page_height: @check.height_page,
             page_width: 80,
             encoding: 'utf8',
             save_only: true,
             :save_to_file => Rails.root.join('public/checks', file_name)
      # Печатаем сгенерированный файл
      @check.print(file_name)
    end
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

  def paid
    if @check.paid
      render json: @check.front_view_with_name_key, status: :ok
    else
      render json: @check.errors, status: 400
    end
  end

  def save
    @errors = []
    Check.transaction do
      checks_params[:checks].each do |key, check|
        if key.to_i.negative?
          @check = Check.new(check.permit(:client, :placeTitle, :summ, :cash_box_id, :cashBoxTitle, :cashBoxDiscount))
        else
          @check = Check.find(key)
          @check.attributes = check.permit(:client, :placeTitle, :summ, :cash_box_id, :cashBoxTitle, :cashBoxDiscount)
        end
        @check.printed = true
        check[:check_item_ids].each do |checkItemId|
          if checkItemId.negative?
            @checkItem = CheckItem.new(check_items2_params[:checkItems][checkItemId.to_s])
          else
            @checkItem = CheckItem.find(checkItemId)
            @checkItem.attributes = check_items2_params[:checkItems][checkItemId.to_s]
          end
          @check.check_items << @checkItem
        end
        if check[:check_item_delete_ids].present?
          check[:check_item_delete_ids].each do |checkItemId|
            CheckItem.find(checkItemId).delete if checkItemId.positive?
          end
        end
        # TODO: Вынести во фронте отдельные запуски удаления чеков
        if checks_delete_params[:deleteCheckIds].present?
          Check.where(id: checks_delete_params[:deleteCheckIds]).destroy_all
        end
        @check.order = @order
        @errors << @check.error unless @check.save!
      end
    end
    if @errors.empty?
      result = {}.merge!(@order.front_view_with_name_key)
        .merge!(@order.checks.front_view_with_name_key)
          .merge!(@order.check_items.front_view_with_name_key)
      render json: result, status: :ok
    else
      render json: @errors, status: 400
    end
  end

  private

  def set_order
    @order = Order.find(params[:order][:id])
  end

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

  def checks_params
    params.permit(checks: [:client, :placeTitle, :summ, :cash_box_id, :cashBoxTitle, :cashBoxDiscount, check_item_ids: [], check_item_delete_ids: []])
  end

  def check_items2_params
    params.permit(checkItems: [:qty, :summ, :techCardPrice, :techCardTitle, :tech_card_id, :discount])
  end

  def checks_delete_params
    params.permit(deleteCheckIds: [])
  end
end
