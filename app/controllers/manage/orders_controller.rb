class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_roles
  before_action :set_order, only: [:edit, :approve, :reject]

  layout 'layouts/manage'

  def index
    if params[:sort] == 'complete' or params[:sort] == 'rejected'
      @orders = current_store.orders.department(spree_current_user).where(state: params[:sort].to_sym).order(:state, created_at: :desc)
    else
      @orders = current_store.orders.department(spree_current_user).where(state: :awaiting_approval).order(:state, created_at: :desc)
    end
  end

  def approve
    @order.completed_by(spree_current_user)
    Spree::OrderMailer.order_approved(@order).deliver_later
    admins.each do |admin|
      Spree::OrderMailer.order_notify_admin(@order, admin).deliver_later
    end
    flash.notice = "Order ##{@order.number} has been approved."
    redirect_to manage_orders_path
  end

  def reject
    @order.rejected_by(spree_current_user)
    spree_current_user.department.decrease_budget_used(@order.total)
    Spree::OrderMailer.cancel_email(@order).deliver_later
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
