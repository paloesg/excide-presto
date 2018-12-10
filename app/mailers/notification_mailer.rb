class NotificationMailer < ApplicationMailer
  default from: 'Excide admin@excide.co'
  layout 'mailer'

  def new_service_request(service_request)
    @users = Spree::Role.find_by_name('admin').users
    @service_request = service_request
    @users.each do |user|
      notification_service_request(service_request, user).deliver
    end
  end

  def notification_service_request(service_request, user)
    @service_request = service_request
    mail(to: user.email, subject: '[New Service Request] ' + @service_request.service_name)
  end
end