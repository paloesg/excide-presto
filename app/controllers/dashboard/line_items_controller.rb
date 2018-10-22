class Dashboard::LineItemsController < ApplicationController

  def destroy
    @line_item = Spree::LineItem.find(params[:id])
    @line_item.destroy
  end
end
