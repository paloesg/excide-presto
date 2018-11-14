class AuthenticationMailer < ApplicationMailer
  default from: 'admin@excide.co'
  
  def registration_email(user)
    p "hello"
    @user = user
    p @user
    @default_send_to_email = 'admin@excide.co'
    mail(to: @default_send_to_email, subject: 'New User Data to registration')
  end
end
