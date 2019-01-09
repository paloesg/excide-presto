Spree::CheckoutController.class_eval do
  def update
    @order = current_order(lock: true)
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.completed?
        @current_order = nil
        admin_users = Spree::Role.find_by_name('admin').users
        admin_users.each do |admin|
          OrderMailer.order_request(@order, admin).deliver_now
        end
        managers = Spree::Role.get_manager_by_department(current_store, @order.user)
        managers.each do |manager|
          OrderMailer.order_request_to_manager(@order, manager).deliver_now
        end
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
        @order.approved_by(@order.user) if managers.empty? or @order.user.has_spree_role? :manager
      elsif @order.awaiting_approval?
        flash.notice = 'Your order has been submitted and is currently awaiting approval from your department manager.'
        @order.finalize!
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

end