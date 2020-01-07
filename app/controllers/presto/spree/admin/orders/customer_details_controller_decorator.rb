module Presto
  module Spree
    module Admin
      module Orders
        module CustomerDetailsController
          def self.prepended(base)
            after_action :generate_purchase_order, only: :update
          end

          def generate_purchase_order
            GeneratePurchaseOrderJob.perform_later(load_order)
          end
        end
      end
    end
  end
end