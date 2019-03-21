class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_roles
  before_action :set_order, only: [:edit, :approve, :reject]

  layout 'layouts/manage'

  def index
    @orders = current_store.orders.department(spree_current_user).order(created_at: :desc)
  end

  def approve
    @order.completed_by(spree_current_user)
    @order.update_with_updater!
    Spree::OrderMailer.order_approved(@order).deliver_later
    admins.each do |admin|
      Spree::OrderMailer.order_notify_admin(@order, admin).deliver_later
    end
    flash.notice = "Order ##{@order.number} has been approved."
    GeneratePurchaseOrderJob.perform_later(@order)
    redirect_to manage_orders_path
  end

  def reject
    @order.rejected_by(spree_current_user)
    @order.update_with_updater!
    Spree::OrderMailer.order_rejected(@order).deliver_later
    flash.notice = "Order ##{@order.number} has been rejected."
    redirect_to manage_orders_path
  end

  private

  def admins
    Spree::Role.find_by_name('admin').users
  end

  def set_roles
    unless spree_current_user.has_spree_role? :manager
      flash[:error] = 'Authorization Failure'
      redirect_to forbidden_path
    end
  end

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
