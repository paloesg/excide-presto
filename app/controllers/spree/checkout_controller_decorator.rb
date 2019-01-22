Spree::CheckoutController.class_eval do
  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
        @order.approved_by(@order.user) if managers.empty? or @order.user.has_spree_role? :manager
      elsif @order.awaiting_approval?
        send_email_to_manager
        @order.finalize!
        flash.notice = 'Your order has been processed successfully, awaiting for approval'
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

  private

  def send_email_to_manager
    managers = Spree::Role.get_manager_by_department(current_store, @order.user)
    managers.each do |manager|
      Spree::OrderMailer.request_approval_to_manager(@order, manager).deliver_now
    end
  end

  def set_order
    @order = current_order(lock: true)
  end
end