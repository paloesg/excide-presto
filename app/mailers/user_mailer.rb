class UserMailer < ApplicationMailer
  default from: 'admin@excide.co'

  def registration_email(user)
    @user = user
    @default_send_to_email = 'admin@excide.co'
    mail(to: @default_send_to_email, subject: 'Register New Account')
  end
end
