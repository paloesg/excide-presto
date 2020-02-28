module Presto
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.alias_method :orig_price_in, :price_in
        base.has_many :product_sales
      end

      def price_in(currency, store_id = nil)
        current_store_id = store_id ? store_id : ::Spree::Store.current.id
        if self.product_sales.find_by(store_id: current_store_id).present?
          product_sale = self.product_sales.find_by(store_id: current_store_id)
          ::Spree::Price.new(variant_id: self.id, amount: product_sale.sale_price, currency: currency)
        else
          prices.detect { |price| price.currency == currency } || prices.build(currency: currency)
        end
      end
    end
  end
end

::Spree::Variant.prepend Presto::Spree::VariantDecorator