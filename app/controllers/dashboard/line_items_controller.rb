class Dashboard::LineItemsController < ApplicationController

  def destroy
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
    @line_item = Spree::LineItem.find(params[:id])
    @line_item.destroy
    redirect_to edit_dashboard_order_path(order_id: @order.number)
  end
end
