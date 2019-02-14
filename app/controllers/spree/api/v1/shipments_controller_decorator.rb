Spree::Api::V1::ShipmentsController.class_eval do
  before_action :find_and_update_shipment, only: [:ship, :delivered, :ready, :add, :remove]

  def delivered
    @shipment.delivered! unless @shipment.delivered?
    respond_with(@shipment, default_template: :show)
  end
end