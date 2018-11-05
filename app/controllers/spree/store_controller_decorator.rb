Spree::StoreController.class_eval do
  skip_before_action :require_login, only: :cart_link
end