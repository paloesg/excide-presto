class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def logged_in?
    spree_current_user != nil
  end

  def require_login
    unless logged_in?
      flash[:error] = "Please Login or Sign Up"
      redirect_to spree_login_path
    end
  end
end
