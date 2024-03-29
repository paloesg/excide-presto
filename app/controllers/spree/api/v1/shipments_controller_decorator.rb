Spree::Api::V1::ShipmentsController.class_eval do
  before_action :find_and_update_shipment, only: [:ship, :delivery, :ready, :add, :remove]

  def delivery
    @shipment.delivery! unless @shipment.delivered?
    @shipment.order.update_with_updater!
    @shipment.delivered_at = Time.current
    @order = @shipment.order
    GenerateInvoiceJob.perform_later(@order)
    @shipment.save
    respond_with(@shipment, default_template: :show)
  end

  # Override `ship` action, to add the generate delivery order after order is shipped
  def ship
    @shipment.ship! unless @shipment.shipped?
    @order = @shipment.order
    GenerateDeliveryOrderJob.perform_later(@order)
    respond_with(@shipment, default_template: :show)
  end
end