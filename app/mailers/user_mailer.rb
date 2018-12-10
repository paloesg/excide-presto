class UserMailer < ApplicationMailer

  default from: 'admin@excide.co'

  def registration_email(user)
    @user = user
    @default_send_to_email = 'admin@excide.co'
    mail(to: @default_send_to_email, subject: 'Register New Account')
  end

  def new_password_instructions(from_address, user, token, *_args)
    @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: Spree::Store.current.url)

    mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :new_password_instructions])
  end
end
