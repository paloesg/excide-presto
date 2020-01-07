
module Presto
  module Spree
    module LineItemDecorator
      # include Spree::Core::ControllerHelpers::Store
      # require 'spree/core/controller_helpers/store'

      def update_price
        store = Spree::Store.current
        current_store_id = store.id
        self.price = variant.product_sales.find_by(store_id: current_store_id) ? variant.product_sales.find_by(store_id: current_store_id).sale_price : variant.price_including_vat_for(tax_zone: tax_zone)
      end
    end
  end
end