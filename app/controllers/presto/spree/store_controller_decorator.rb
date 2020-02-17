module Presto
  module Spree
    module StoreControllerDecorator
    end
  end
end

::Spree::StoreController.prepend Presto::Spree::StoreControllerDecorator