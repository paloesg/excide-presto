Spree::OrdersController.class_eval do
  respond_override populate: { html: { success: lambda { render js: 'Spree.fetch_cart();$("#productContent").modal("hide")' } } }

  def reorder
    order    = current_order(create_order_if_necessary: true)
    order.empty!
    rejected_order  = Spree::Order.find_by_number(params[:id])
    rejected_order.line_items.each do |line_item|
      order.contents.add(line_item.variant, line_item.quantity, {})
    end
    order.update_line_item_prices!
    order.create_tax_charge!
    order.update_with_updater!
    redirect_to cart_path
  end

  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}
    # render json: variant.to_json

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity, options)
        order.update_line_item_prices!
        order.create_tax_charge!
        order.update_with_updater!
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(', ')
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
        format.html { redirect_to(cart_path(variant_id: variant.id)) }
      end
    end
  end

  def check_authorization
  end
end