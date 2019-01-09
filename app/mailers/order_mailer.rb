class OrderMailer < ApplicationMailer
  layout 'mailer'

  def order_request(order, admin)
    sent_to = admin.email
    @order = order
    mail to: sent_to, subject: Spree::Store.current.name + ' New Order Request'
  end

  def request_approval_to_manager(order, manager)
    sent_to = manager.email
    @order = order
    mail to: sent_to, subject: Spree::Store.current.name + ' New Order Request - Awaiting Your Approval'
  end
end
