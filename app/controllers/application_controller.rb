class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def logged_in?
    spree_current_user != nil
  end

  def default_store
    Spree::Store.find_by_default(true)
  end

  def redirect_to_user_company_store
    # Check user company domain and domain is match with current site domain
    if spree_current_user&.company&.store&.url && spree_current_user&.company&.store&.url != request.host
      unless spree_current_user.has_spree_role?('admin') && params[:controller].include?('spree/admin')
        redirect_to "http://#{spree_current_user.company&.store&.url}"
      end
    elsif spree_current_user&.company.nil? && default_store.url.lines.first.chomp != request.host
      redirect_to "http://#{default_store.url.lines.first}"
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