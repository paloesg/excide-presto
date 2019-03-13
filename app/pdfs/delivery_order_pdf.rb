class DeliveryOrderPdf < Prawn::Document
  include GeneratePdf

  def initialize(order)
    super(top_margin: 70)
    @order = order
    @company = @order.user.company

    # row logo
    logo
    delivery_order

    # row company details
    company_name
    order_date
    order_number

    # row bill to
    deliver_to
    delivery_address

    # table order line items
    line_items
    total_price

    # row footer
    move_cursor_to 80
    horizontal_line 0, 230
    horizontal_line 420, 540
    receiver_signature
    date
    move_down 25
    footer
  end

  def delivery_order
    move_up 20
    text "DELIVERY ORDER", size: 15, align: :right, color: "878787"
  end

  def company_name
    move_down 40
    text @company.name
  end

  def deliver_to
    move_down 20
    text "DELIVER TO", size: 11
    horizontal_line 0, 230
    move_down 4
    span(200, position: :left) do
      text "#{@order.ship_address.first_name} #{@order.ship_address.last_name}", size: 11
    end
  end

  def delivery_address
    move_up 28
    text "DELIVERY ADDRESS", align: :right, size: 11
    horizontal_line 350, 540
    move_down 4
    span(200, position: :right) do
      text @order.ship_address.address1, size: 10, align: :right
      text @order.ship_address.address2, size: 10, align: :right
      text @order.ship_address.city, size: 10, align: :right
      text @order.ship_address.phone, size: 10, align: :right
     end
  end

  def receiver_signature
    move_up 50
    text "THANK YOU", size: 20
    move_down 30
    text "RECEIVER'S SIGNATURE / COMPANY STAMP", size: 11
  end

  def date
    move_up 13
    text "Time of Receipt", align: :right
  end

  def footer
    text "For questions concerning this delivery order, please contact", align: :center, size: 10
    text "+65 6285 0320, customercare@gobblerco.com", align: :center, size: 10
    text "<u><link href='https://gobblerco.com'>gobblerco.com</link></u>", align: :center, size: 11, inline_format: true
  end
end