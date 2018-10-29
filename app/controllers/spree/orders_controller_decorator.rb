Spree::OrdersController.class_eval do
	before_action :set_cart
  respond_override populate: { html: { success: lambda { render json: set_cart.to_json } } }

	private

  def set_cart
    @order = current_order
    @cart = { total: @order[:total], item_count: @order[:item_count] }
  end
end