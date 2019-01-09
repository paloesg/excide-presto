Spree::OrderMailer.class_eval do
  def confirm_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    @managers = Spree::Role.get_manager_by_department(Spree::Store.current, @order.user)
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
end