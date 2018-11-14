class AuthenticationsController < ApplicationController
  skip_before_action :require_login
  include Spree::Core::ControllerHelpers::Store

  def registration
    @user = params
    AuthenticationMailer.registration_email(@user).deliver_now
    redirect_to "/login", flash: {message: "success"} 
  end
end
