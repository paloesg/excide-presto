module Presto
  module Spree
    module UserSessionsController
      def self.prepended(base)
        skip_before_action :require_login
      end
    end
  end
end