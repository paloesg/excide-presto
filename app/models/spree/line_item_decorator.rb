Spree::LineItem.class_eval do
  # include Spree::Core::ControllerHelpers::Store
  # require 'spree/core/controller_helpers/store'

  def update_price
    store = Spree::Core::ControllerHelpers::Store.current_store
    current_store_id = store.id
    self.price = variant.product_sales.find(store_id: current_store_id) ? variant.product_sales.find(store_id: current_store_id).sale_price : variant.price_including_vat_for(tax_zone: tax_zone)
  end
end