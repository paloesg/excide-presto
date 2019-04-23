class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def logged_in?
    spree_current_user != nil
  end

  def require_login
    redirect_to spree_login_path unless logged_in?
  end
end
