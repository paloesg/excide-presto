class OrderMailer < ApplicationMailer
  layout 'mailer'

  def order_request(order, user, admin)
    sent_to = admin.email
    @user = user
    @order = order
    mail to: sent_to, subject: Spree::Store.current.name + ' New Order Request'
  end

  def order_rejected(order, user, admin)
    sent_to = user.email
    from_address = admin.email
    @user = user
    @order = order
    mail to: sent_to, from: from_address, subject: Spree::Store.current.name + ' Order Rejected'
  end

  def order_approved(order, user, admin)
    sent_to = user.email
    from_address = admin.email
    @user = user
    @order = order
    mail to: sent_to, from: from_address, subject: Spree::Store.current.name + ' Order Approved'
  end

end
