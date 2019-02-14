Spree::CheckoutController.class_eval do
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