class Dashboard::OrdersController < ApplicationController
layout 'dashboard/application'

  def edit
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
