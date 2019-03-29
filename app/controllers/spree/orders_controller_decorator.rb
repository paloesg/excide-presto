Spree::OrdersController.class_eval do
  before_action :rejected_order, only: [:edit_rejected, :reorder_rejected]

  def update
    @variant = Spree::Variant.find(params[:variant_id]) if params[:variant_id]
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

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
    variant = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options = params[:options] || {}
    line_item = order.line_items.find_by(variant_id: variant.id)
    line_item_quantity = line_item&.quantity&.to_i || 0
    last_quantity = line_item_quantity + quantity
    line_item_price = (line_item&.price || variant.product.price) * quantity

    if quantity
      if exceed_budget?(line_item_price)
        error = Spree.t('order.budget_exceeded')
      else
        begin
          if last_quantity >= 1
            result = cart_add_item_service.call(order: order,
                                        variant: variant,
                                        quantity: quantity,
                                        options: options)
            if result.failure?
              error = result.value.errors.full_messages.join(', ')
            end
          else
            order.contents.remove_line_item(line_item, options)
          end
          order.update_line_item_prices!
          order.create_tax_charge!
          order.update_with_updater!
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.full_messages.join(', ')
        end
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
        format.html { render js: "fetch_navbar_cart(#{order.line_items.sum(:quantity)});" }
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

  def exceed_budget?(line_item_price)
    if spree_current_user&.department&.budget.nil?
      return false
    elsif (spree_current_user.department.budget - spree_current_user.department.budget_used - line_item_price) < 0
      return true
    else
      return false
    end
  end

end
