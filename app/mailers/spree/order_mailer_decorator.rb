Spree::OrderMailer.class_eval do
  def confirm_order(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    @managers = Spree::Role.get_manager_by_department(@order.user)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} your Order ##{@order.number} is waiting for Approval from Manager"
    mail(to: @order.email, from: from_address, subject: subject)
  end

  def approve_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} order Approved ##{@order.number}"
    mail(to: @order.email, from: from_address, subject: subject)
  end

  def request_approval_to_manager(order, manager)
    sent_to = manager.email
    @order = order
    mail to: sent_to, from: from_address, subject: Spree::Store.current.name + ' New Order Request - Awaiting Your Approval'
  end

  def confirm_order_approved(order, admin)
    sent_to = admin.email
    @order = order
    mail to: sent_to, from: from_address, subject: Spree::Store.current.name + " order Approved ##{@order.number}"
  end
end