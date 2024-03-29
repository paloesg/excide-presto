class NotificationMailer < ApplicationMailer
  default from: 'Excide Presto <admin@excide.co>'
  layout 'mailer'

  def new_service_request(service_request, user)
    @service_request = service_request
    mail(to: user.email, subject: '[New Service Request] ' + @service_request.service_name)
  end
end