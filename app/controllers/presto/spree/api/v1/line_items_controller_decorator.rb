module Presto
  module Spree
    module Api
      module V1
        module LineItemsController
          def self.prepended(base)
            after_action :generate_purchase_order
          end

          def generate_purchase_order
            GeneratePurchaseOrderJob.perform_later(order)
          end
        end
      end
    end
  end
end