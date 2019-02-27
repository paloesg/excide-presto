class InvoicePdf < Prawn::Document
  def initialize(order)
    super(top_margin: 70)
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

  def logo
    text "GOBBLER", size: 25, color: "d9d9d9"
  end

  def invoice
    move_up 20
    text "INVOICE", size: 15, align: :right, color: "878787"
  end

  def company_details
    move_down 20
    text @company.name
  end

  def order_date
    move_up 20
    text "DATE", align: :right, size: 11
    horizontal_line_left
    move_down 4
    text @order.created_at.strftime("%d/%m/%Y"), align: :right, size: 10
  end

  def order_number
    move_down 5
    text "ORDER NUMBER", align: :right, size: 11
    horizontal_line_left
    move_down 4
    text @order.number, align: :right, size: 10
  end

  def bill_to
    move_down 20
    text "BILL TO", size: 11
    horizontal_line 0, 230
    move_down 4
    span(200, position: :left) do
      text @order.bill_address.address1, size: 10
      text @order.bill_address.address2, size: 10
      text @order.bill_address.city, size: 10
      text @order.bill_address.phone, size: 10
    end
  end

  def line_items
    move_down 20
    table line_items_rows, width: bounds.width, cell_style: {size: 9} do
      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(0).border_width = 0.5
      row(0).align = :center
      row(1..99).columns(1..3).align = :right
      self.header = true
    end
  end

  def line_items_rows
    [['PRODUCT', 'PRICE', 'QUANTITY', 'TOTAL PRICE']] +
    @order.line_items.map do |item|
      [item.name, item.single_money.to_html, item.quantity, item.display_amount.to_html]
    end
  end

  def total_price
    move_down 15
    text "Total Price: #{@order.display_total}", size: 12, style: :bold, align: :right
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

  def footer
    text "For questions concerring this invoice, please contact", align: :center, size: 10
    text "+65 6285 0320, customercare@gobblerco.com", align: :center, size: 10
    text "<u><link href='http://gobblerco.com'>gobblerco.com</link></u>", align: :center, size: 11, inline_format: true
  end

  def horizontal_line_left
    horizontal_line 420, 540
  end
end