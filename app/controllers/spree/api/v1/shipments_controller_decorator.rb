Spree::Api::V1::ShipmentsController.class_eval do
  before_action :find_and_update_shipment, only: [:ship, :delivery, :ready, :add, :remove]

  def delivery
    @shipment.delivery! unless @shipment.delivered?
    @shipment.order.update_with_updater!
    @shipment.delivered_at = Time.current
    @shipment.save
    respond_with(@shipment, default_template: :show)
  end
end