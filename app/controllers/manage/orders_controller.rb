class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_order, only: [:edit, :approve, :cancel]

  layout 'layouts/manage'

  def index
    @orders = current_store.orders.department(spree_current_user).where.not(state: :cart).order(:state, created_at: :desc)
    authorize! :read, @orders
  end

  def approve
    @order.approved_by(spree_current_user)
    Spree::OrderMailer.approve_email(@order).deliver_later
    redirect_to manage_orders_path
  end

  def cancel
    @order.canceled_by(spree_current_user)
    redirect_to manage_orders_path
  end

  private

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
