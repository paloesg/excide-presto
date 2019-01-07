Spree::OrderMailer.class_eval do
  def approve_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
    subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
    subject += "#{Spree::Store.current.name} order Approved ##{@order.number}"
    mail(to: @order.email, from: from_address, subject: subject)
  end
end