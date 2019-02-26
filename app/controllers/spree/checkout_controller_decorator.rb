Spree::CheckoutController.class_eval do
  def update
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      if params[:order][:use_company_address] == "1"
        @order.clone_company_address
      end
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to(checkout_state_path(@order.state)) && return
      end

      if @order.awaiting_approval?
        @order.finalize!
        total_order_price = @order.total
        company_preapproved_limit = spree_current_user.company.preapproved_limit if spree_current_user.company.present?
        #set automaticaly approved when company have limit order price and the order price less than the company limit or the user don't have manager or the user as manager
        if (company_preapproved_limit.present? and company_preapproved_limit >= total_order_price) or managers.blank? or @order.user.has_spree_role? :manager
          @order.completed_by(@order.user)
          Spree::OrderMailer.order_approved(@order.id).deliver_later
          admins.each do |admin|
            Spree::OrderMailer.order_notify_admin(@order, admin).deliver_later
          end
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

  def admins
    Spree::Role.find_by_name('admin').users
  end

  def set_order
    @order = current_order(lock: true)
  end
end