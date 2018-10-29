Spree::OrdersController.class_eval do
  respond_override populate: { html: { success: lambda { render json: cart } } }

	private

  def cart
    order = current_order
    @cart = { total: order[:total], item_count: order[:item_count] }
  end
end