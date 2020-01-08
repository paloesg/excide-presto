module Presto
  module Spree
    module Api
      module V1
        module LineItemsControllerDecorator
          def self.prepended(base)
            base.after_action :generate_purchase_order
          end

          def generate_purchase_order
            GeneratePurchaseOrderJob.perform_later(order)
          end
        end
      end
    end
  end
end

::Spree::Api::V1::LineItemsController.prepend Presto::Spree::Api::V1::LineItemsControllerDecorator