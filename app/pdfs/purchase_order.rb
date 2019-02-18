class PurchaseOrder < Prawn::Document
  def initialize(order)
    super(top_margin: 70)
    @order = order
    @company = @order.user.company

    # row logo
    logo
    purchase_order

    # row company details
    company_details
    order_date
    order_number

    # row bill to
    bill_to
    ship_to

    # table order line items
    line_items

    # row footer
    total_price
    authorized_signature
    date
    footer
  end

  def logo
    text "GOBBLER", size: 25, color: "d9d9d9" 
  end

  def purchase_order
    move_up 20
    text "PURCHASE ORDER", size: 15, align: :right, color: "878787"
  end

  def company_details
    move_down 20
    text @company.name
  end

  def order_date
    move_up 20
    text "DATE", align: :right
    horizontal_line_left
    move_down 4
    text @order.created_at.strftime("%d/%m/%Y"), align: :right
  end

  def order_number
    move_down 5
    text "ORDER NUMBER", align: :right
    horizontal_line_left
    move_down 4
    text @order.number, align: :right
  end

  def horizontal_line_left
    horizontal_line 420, 550
  end
  
  def bill_to
    move_down 20
    text "BILL TO"
  end

  def ship_to
    move_up 20
    text "SHIP TO", align: :right
  end 

  def line_items
    move_down 20
    table line_items_rows, width: bounds.width do
      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(0).border_width = 1
      row(0).align = :center
      row(1).columns(1..3).align = :right
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
    text "Total Price: #{@order.display_total}", size: 16, style: :bold, align: :right
  end

  def authorized_signature
    move_down 15
    text "AUTHORIZED SIGNATURE"
  end

  def date
    move_up 15
    text "DATE", align: :right
  end

  def footer
    move_down 15
    text "For questions concerring this invoice, please contact", align: :center
    text "Name, Phone, Email Address", align: :center
    text "gobblerco.herokuapp.com", align: :center
  end
end