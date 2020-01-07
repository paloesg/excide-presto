module Presto
  module Spree
    module StoreController
      def self.prepended(base)
        skip_before_action :require_login, only: :cart_link
      end
    end
  end
end