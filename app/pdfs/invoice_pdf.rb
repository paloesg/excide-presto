class InvoicePdf < GeneratePdf
  def initialize(order)
    @order = order
    @company = @order.user.company

    # row logo
    logo
    invoice

    # row company details
    company_details
    order_date
    order_number

    # row bill to
    bill_to

    # table order line items
    line_items
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

  def title
    move_up 20
    text "INVOICE", size: 15, align: :right, color: "878787"
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