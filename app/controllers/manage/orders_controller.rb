class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_order, only: [:edit, :approve, :reject]

  layout 'layouts/manage'

  def index
    @orders = current_store.orders.department(spree_current_user).order(created_at: :desc)
    authorize! :read, @orders
  end

  def approve
    @order.update_columns(state: 'complete', updated_at: Time.current)
    @order.approved_by(spree_current_user)
    Spree::OrderMailer.approve_email(@order).deliver_later
    admins.each do |admin|
      Spree::OrderMailer.confirm_order_approved(@order, admin).deliver_now
    end
    flash.notice = "The order with order number #{@order.number}, has been approved."
    redirect_to manage_orders_path
  end

  def reject
    @order.update_columns(state: 'rejected', updated_at: Time.current)
    @order.canceled_by(spree_current_user)
    Spree::OrderMailer.cancel_email(@order).deliver_later
    admins.each do |admin|
      Spree::OrderMailer.confirm_order_rejected(@order, admin).deliver_now
    end
    flash.notice = "The order with order number #{@order.number}, has been rejected."
    redirect_to manage_orders_path
  end

  private

  def admins
    Spree::Role.find_by_name('admin').users
  end

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
