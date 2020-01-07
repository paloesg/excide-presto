module Presto
  module Spree
    module BaseHelperDecorator
      def display_price(product_or_variant)
        product_or_variant.
        price_in(current_currency, current_store.id).
        display_price_including_vat_for(current_price_options).
        to_html
      end
    end
  end
end