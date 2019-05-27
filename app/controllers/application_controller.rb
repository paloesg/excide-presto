class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def logged_in?
    spree_current_user != nil
  end

  def redirect_to_user_company_store
    # Check user company domain and domain is match with current site domain
    if spree_current_user&.company&.store != current_store and !spree_current_user.has_spree_role?('admin')
      redirect_to "http://#{spree_current_user.company&.store&.url}"
    end
  end

  def require_login
    unless logged_in?
      redirect_to spree_login_path
    else
      redirect_to_user_company_store
    end
  end
end
