Spree::CheckoutController.class_eval do
  def before_delivery
    return if params[:order].present?

    packages = @order.shipments.map(&:to_package)
    @differentiator = Spree::Stock::Differentiator.new(@order, packages)

    #we select the shipping for the user
    @order.select_default_shipping
    @order.next

    #default logic for finalizing unless he can't select payment_method
    if @order.completed?
      session[:order_id] = nil
      flash.notice = Spree.t(:order_processed_successfully)
      flash[:commerce_tracking] = "nothing special"

      return redirect_to completion_route
    else
      return redirect_to checkout_state_path(@order.state)
    end

  end

  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.awaiting_approval?
        @order.finalize!
        if managers.blank? or @order.user.has_spree_role? :manager
          @order.completed_by(@order.user)
          Spree::OrderMailer.order_approved(@order.id).deliver_later
          flash.notice = 'Your order has been processed successfully'
          generate_pdf = PurchaseOrderPdf.new(@order)
          @order.create_purchase_order(attachment: {io: StringIO.new(generate_pdf.render), filename: "purchase-order-#{@order.number}.pdf"})
        else
          send_email_to_managers
          @order.deliver_order_confirmation_email
          flash.notice = 'Your order is awaiting approval from your manager'
        end
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
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

  def set_order
    @order = current_order(lock: true)
  end
end