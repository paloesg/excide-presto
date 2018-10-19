class Dashboard::OrdersController < ApplicationController
layout 'dashboard/application'

  def edit
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:id])
  end
end
