module Presto
  module Spree
    module UserSessionsControllerDecorator
    end
  end
end

::Spree::UserSessionsController.prepend Presto::Spree::UserSessionsControllerDecorator