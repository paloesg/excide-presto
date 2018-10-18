class Dashboard::HomeController < ApplicationController
layout 'dashboard/application'

  def show
    @orders = Spree::Order.complete
  end
end
