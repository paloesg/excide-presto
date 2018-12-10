class NotificationMailer < ApplicationMailer
  default from: 'Excide admin@excide.co'
  layout 'mailer'

  def notification_service_request(service_request, user)
    @service_request = service_request
    mail(to: user.email, subject: '[New Service Request] ' + @service_request.service_name)
  end
end