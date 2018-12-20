Spree::CheckoutController.class_eval do
  def update
    @order = current_order(lock: true)
    @user = @order.user
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
          OrderMailer.order_request(@order, @user, admin).deliver_now
        end
        managers = Spree::Role.get_manager_by_department(current_store, @user)
        managers.each do |manager|
          OrderMailer.order_request_to_manager(@order, @user, manager).deliver_now
        end
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
        @order.approved_by(@user) if managers.empty? or @user.has_spree_role? :manager
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

end