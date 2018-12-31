Spree::OrdersController.class_eval do
  respond_override populate: { html: { success: lambda { render js: 'Spree.fetch_cart();$("#productContent").modal("hide")' } } }
  before_action :update_preferred_delivery_datetime, only: :update
  before_action :set_order, only: [:update_preferred_delivery_datetime, :populate]

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
    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}
    line_item = @order.line_items.find_by(variant_id: variant.id)
    line_item_quantity = line_item.present? ? line_item.quantity.to_i : 0
    last_quantity =  line_item_quantity + quantity

    if quantity
      begin
        if last_quantity >= 1
          @order.contents.add(variant, quantity, options)
        else
          @order.contents.remove_line_item(line_item, options)
        end
        @order.update_line_item_prices!
        @order.create_tax_charge!
        @order.update_with_updater!
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
      respond_with(@order) do |format|
        format.html { redirect_to(cart_path(variant_id: variant.id)) }
      end
    end
  end

  private

  def update_preferred_delivery_datetime
    preferred_delivery = []
    params[:order][:preferred_delivery_time].each do |index, time|
      preferred_delivery << "Preferred delivery time #{index}: #{time}"
    end
    @order.update_attribute(:special_instructions, preferred_delivery.join(', '))
  end

  def set_order
    @order    = current_order(create_order_if_necessary: true)
  end
end