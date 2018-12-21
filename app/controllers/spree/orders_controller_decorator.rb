Spree::OrdersController.class_eval do
  respond_override populate: { html: { success: lambda { render js: 'Spree.fetch_cart();$("#productContent").modal("hide")' } } }

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

  def populate
    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    existing_quantity = current_order.line_items.find_by(variant_id: variant.id).quantity
    input_quantity = existing_quantity + quantity
    if input_quantity >= 0
      order.contents.add(variant, quantity, options)
      order.update_line_item_prices!
      order.create_tax_charge!
      order.update_with_updater!
    else
      error = 'Quantity is not match with your order'
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
end