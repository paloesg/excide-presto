class ProductMailer < ApplicationMailer
  default from: "from@example.com"
  layout 'mailer'

  def order_request(order, user, admin)
    sent_to = admin.email
    @user = user
    @order = order
    mail to: sent_to, subject: Spree::Store.current.name + ' New Order Request'
  end
end
