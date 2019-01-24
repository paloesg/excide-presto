class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_order, only: [:edit, :approve, :cancel]

  layout 'layouts/manage'

  def index
    @orders = current_store.orders.department(spree_current_user).order(created_at: :desc)
    authorize! :read, @orders
  end

  def approve
    @order.update_columns(state: 'complete', updated_at: Time.current)
    @order.approved_by(spree_current_user)
    Spree::OrderMailer.approve_email(@order).deliver_later
    redirect_to manage_orders_path
  end

  def cancel
    @order.update_columns(state: 'rejected', updated_at: Time.current)
    @order.canceled_by(spree_current_user)
    Spree::OrderMailer.cancel_email(@order).deliver_later
    redirect_to manage_orders_path
  end

  private

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
