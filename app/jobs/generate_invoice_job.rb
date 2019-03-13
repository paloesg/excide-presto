class GenerateInvoiceJob < ApplicationJob
  queue_as :default

  def perform(order)
    generate_pdf = InvoicePdf.new(order)
    order.create_invoice(attachment: {io: StringIO.new(generate_pdf.render), filename: "invoice-#{order.number}.pdf"})
  end
end
