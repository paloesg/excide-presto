module Presto
  module Spree
    module StoreControllerDecorator
      def self.prepended(base)
        base.skip_before_action :require_login, only: :cart_link
      end
    end
  end
end

::Spree::StoreController.prepend Presto::Spree::StoreControllerDecorator