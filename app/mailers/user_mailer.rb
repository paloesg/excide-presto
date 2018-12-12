class UserMailer < ApplicationMailer

  default from: 'admin@excide.co'

  def registration_email(admin, user)
    sent_to = admin.email
    @user = user
    @approved_link = spree.edit_admin_user_url(id: @user.id, host: Spree::Store.current.url)

    mail to: sent_to, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :register_new_account])
  end

  def new_password_instructions(from_address, user, token, *_args)
    @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: Spree::Store.current.url)

    mail to: user.email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :new_password_instructions])
  end
end
