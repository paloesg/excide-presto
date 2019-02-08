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
        total_price_order = @order.total
        limit_amount_company = spree_current_user.company.default_currency if spree_current_user.company.present?
        if managers.present? or @order.user.has_spree_role? :manager
          @order.approved_by(@order.user)
          flash.notice = 'Your order has been processed successfully'
        elsif limit_amount_company.present? and limit_amount_company.to_f > total_price_order.to_f
          @order.approved_by(@order.user)
          flash.notice = 'Your order has been processed successfully'
        else
          send_email_to_managers
          flash.notice = 'Your order is awaiting for approval from manager'
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
      Spree::OrderMailer.request_approval_to_manager(@order, manager).deliver_now
    end
  end

  def managers
    managers = Spree::Role.get_manager_by_department(current_store, @order.user)
  end

  def set_order
    @order = current_order(lock: true)
  end
end