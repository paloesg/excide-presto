class PurchaseOrderPdf < Prawn::Document
  include GeneratePdf

  def initialize(order)
    super(top_margin: 70)
    @order = order
    @company = @order.user.company

    # row logo
    logo
    title("PURCHASE ORDER")

    # row company details
    company_details
    order_date
    order_number

    # row bill to
    bill_to
    ship_to

    # table order line items
    line_items
    tax
    total_price

    # row footer
    move_cursor_to 75
    horizontal_line 0, 230
    horizontal_line 420, 540
    authorized_signature
    date
    move_down 20
    footer
  end

  def ship_to
    move_up 75
    text "SHIP TO", align: :right, size: 11
    horizontal_line 350, 540
    move_down 4
    span(200, position: :right) do
      if @order.ship_address
        text @order.ship_address.address1, size: 10, align: :right
        text @order.ship_address.address2, size: 10, align: :right
        text @order.ship_address.city, size: 10, align: :right
        text @order.ship_address.phone, size: 10, align: :right
      else
        text @order.bill_address.address1, size: 10, align: :right
        text @order.bill_address.address2, size: 10, align: :right
        text @order.bill_address.city, size: 10, align: :right
        text @order.bill_address.phone, size: 10, align: :right
      end
     end
  end

  def authorized_signature
    move_up 50
    text "THANK YOU", size: 25
    move_down 30
    text "AUTHORIZED SIGNATURE", size: 11
  end

  def date
    move_up 15
    text "DATE", align: :right
  end
end