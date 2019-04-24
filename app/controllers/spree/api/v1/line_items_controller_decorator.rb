Spree::Api::V1::LineItemsController.class_eval do
  after_action :generate_purchase_order

  def generate_purchase_order
    @order = order
    GeneratePurchaseOrderJob.perform_later(@order)
  end
end