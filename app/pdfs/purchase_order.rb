class PurchaseOrder < Prawn::Document
  def initialize(order)
    super(top_margin: 70)
    @order = order
    text "Purchase order, with order number = ##{@order.number}"
  end
end