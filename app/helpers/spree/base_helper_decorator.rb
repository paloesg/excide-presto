Spree::BaseHelper.class_eval do
  def display_price(product_or_variant)
    product_or_variant.
    price_in(current_currency, current_store.id).
    display_price_including_vat_for(current_price_options).
    to_html
  end
end