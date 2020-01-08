module Presto
  module Spree
    module Admin
      module Orders
        module CustomerDetailsControllerDecorator
          def self.prepended(base)
            base.after_action :generate_purchase_order, only: :update
          end

          def generate_purchase_order
            GeneratePurchaseOrderJob.perform_later(load_order)
          end
        end
      end
    end
  end
end

::Spree::Admin::Orders::CustomerDetailsController Presto::Spree::Admin:::Orders::CustomerDetailsControllerDecorator