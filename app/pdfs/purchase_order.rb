class PurchaseOrder < Prawn::Document
  def initialize(order)
    super(top_margin: 70)
    @order = order
    logo
    order_number
    line_items
    total_price
  end

  def logo
    text "GOBBLER", size: 25, color: "d9d9d9" 
  end

  def order_number
    move_up 20
    text "PURCHASE ORDER", size: 15, align: :right, color: "878787"
  end

  def line_items
    move_down 20
    table line_items_rows do
      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(0).border_width = 1
      columns(1..3).align = :right
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
    text "Total Price: #{@order.display_total}", size: 16, style: :bold
  end
end