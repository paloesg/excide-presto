Spree::OrdersController.class_eval do
  before_action :rejected_order, only: [:edit_rejected, :reorder_rejected]

  def edit_rejected
  end

  def reorder_rejected
    @order.update_columns(state: 'awaiting_approval', updated_at: Time.current)
    @order.deliver_order_confirmation_email
    send_email_to_managers
    flash.notice = "Your order with order number #{@order.number}, is awaiting for approval."
    redirect_to account_path
  end

  def populate
    order = Spree::Order.find_by(number: params[:order_number]) || current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    if quantity
      begin
        result = cart_add_item_service.call(order: order,
                                            variant: variant,
                                            quantity: quantity,
                                            options: options)
        if result.failure?
          error = result.value.errors.full_messages.join(', ')
        else
          order.update_line_item_prices!
          order.create_tax_charge!
          order.update_with_updater!
        end
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(', ')
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      respond_to do |format|
        format.html { render json: error, status: :unprocessable_entity }
      end
    else
      respond_with(order) do |format|
        format.html { render json: {order: order} }
      end
    end
  end

  def override_purchase_order
    order   = Spree::Order.find_by(number: params[:id])
    respond_to do |format|
      if order.purchase_order.update(attachment: params[:attachment])
        format.js { render js: 'location.reload();' }
      else
        format.js { render js: 'alert("Error update purchase order pdf file!")' }
      end
    end
  end

  def cart_partial
    @order = Spree::Order.find(current_order.id)
    respond_to do |format|
        format.js
    end
  end

  def reorder_partial
    @order = Spree::Order.find_by(number: params[:order_number])
    respond_to do |format|
        format.js
    end
  end

  private

  def send_email_to_managers
    managers.each do |manager|
      Spree::OrderMailer.order_request_approval_manager(@order, manager).deliver_later
    end
  end

  def managers
    managers = Spree::Role.get_manager_by_department(@order.user)
  end

  def rejected_order
    @order = Spree::Order.includes(line_items: [variant: [:option_values, :images, :product]], bill_address: :state, ship_address: :state).find_by!(number: params[:id])
  end

end
