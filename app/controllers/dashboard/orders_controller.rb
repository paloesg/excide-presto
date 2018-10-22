class Dashboard::OrdersController < ApplicationController
layout 'dashboard/application'

  def edit
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end

  def approve
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
    @order.approved_by(spree_current_user)
    render dashboard_orders_path
  end
end
