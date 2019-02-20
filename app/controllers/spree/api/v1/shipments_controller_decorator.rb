Spree::Api::V1::ShipmentsController.class_eval do
  before_action :find_and_update_shipment, only: [:ship, :delivery, :ready, :add, :remove]

  def delivery
    @shipment.delivery! unless @shipment.delivered?
    @shipment.order.update_with_updater!
    @shipment.delivered_at = Time.current
    @order = @shipment.order
    generate_pdf = InvoicePdf.new(@order)
    @order.create_invoice(attachment: {io: StringIO.new(generate_pdf.render), filename: "invoice-#{@order.number}.pdf"})
    @shipment.save
    respond_with(@shipment, default_template: :show)
  end

  # Override `ship` action, to add the generate delivery order after order is shipped
  def ship
    @shipment.ship! unless @shipment.shipped?
    @order = @shipment.order
    generate_pdf = DeliveryOrderPdf.new(@order)
    @order.create_delivery_order(attachment: {io: StringIO.new(generate_pdf.render), filename: "delivery-order-#{@order.number}.pdf"})
    respond_with(@shipment, default_template: :show)
  end
end