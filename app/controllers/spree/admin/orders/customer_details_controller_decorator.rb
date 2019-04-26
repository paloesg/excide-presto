Spree::Admin::Orders::CustomerDetailsController.class_eval do
  after_action :generate_purchase_order, only: :update

  def generate_purchase_order
    GeneratePurchaseOrderJob.perform_later(load_order)
  end
end