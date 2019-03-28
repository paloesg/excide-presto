class GenerateDeliveryOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    generate_pdf = DeliveryOrderPdf.new(order)
    order.create_delivery_order(attachment: {io: StringIO.new(generate_pdf.render), filename: "delivery-order-#{order.number}.pdf"})
  end
end
