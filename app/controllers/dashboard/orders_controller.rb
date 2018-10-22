class Dashboard::OrdersController < ApplicationController
layout 'dashboard/application'

  def edit
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end

  def approve
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
    @order.approved_by(spree_current_user)
    redirect_to dashboard_root_path
  end

  def cancel
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
    @order.canceled_by(spree_current_user)
    redirect_to dashboard_root_path
  end
end
