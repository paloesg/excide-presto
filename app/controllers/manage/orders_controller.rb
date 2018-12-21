class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_order

  layout 'layouts/manage'

  def index
    @orders = Spree::Order.complete
  end

  def approve
    @order.approved_by(spree_current_user)
    redirect_to dashboard_root_path
  end

  def cancel
    @order.canceled_by(spree_current_user)
    redirect_to dashboard_root_path
  end

  private

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
