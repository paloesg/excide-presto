class GeneratePurchaseOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    generate_pdf = PurchaseOrderPdf.new(order)
    order.create_purchase_order(attachment: {io: StringIO.new(generate_pdf.render), filename: "purchase-order-#{order.number}.pdf"})
  end
end
