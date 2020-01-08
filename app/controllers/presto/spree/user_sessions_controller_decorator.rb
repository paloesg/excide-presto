module Presto
  module Spree
    module UserSessionsControllerDecorator
      def self.prepended(base)
        base.skip_before_action :require_login
      end
    end
  end
end

::Spree::UserSessionsController.prepend Presto::Spree::UserSessionsControllerDecorator