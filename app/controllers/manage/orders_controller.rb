class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  before_action :set_roles
  before_action :set_order, only: [:edit, :approve, :reject]

  layout 'layouts/manage'

  def index
    if spree_current_user.has_spree_role? :manager
      @orders = current_store.orders.department(spree_current_user)
    elsif spree_current_user.has_spree_role? :finance
      @orders = current_store.orders.company(spree_current_user)
    end

    if params[:sort] == 'complete' or params[:sort] == 'rejected'
      @orders = @orders.where(state: params[:sort].to_sym).where.not(shipment_state: ['shipped', 'delivered']).order(:state, created_at: :desc)
    elsif params[:sort] == 'shipped' or params[:sort] == 'delivered'
      @orders = @orders.where(shipment_state: params[:sort].to_sym)
      #get data from spree_shipments because need to get shipped_at or delivered_at the shipment order
      @shipments = Spree::Shipment.where('order_id IN (?)', @orders.pluck(:id)).order(params[:sort] == 'shipped' ? 'shipped_at DESC' : 'delivered_at DESC')
    else
      @orders = @orders.where(state: :awaiting_approval).order(:state, created_at: :desc)
    end
  end

  def approve
    @order.completed_by(spree_current_user)
    @order.update_with_updater!
    Spree::OrderMailer.order_approved(@order).deliver_later
    admins.each do |admin|
      Spree::OrderMailer.order_notify_admin(@order, admin).deliver_later
    end
    flash.notice = "Order ##{@order.number} has been approved."
    redirect_to manage_orders_path
  end

  def reject
    @order.rejected_by(spree_current_user)
    @order.update_with_updater!
    Spree::OrderMailer.cancel_email(@order).deliver_later
    flash.notice = "Order ##{@order.number} has been rejected."
    redirect_to manage_orders_path
  end

  private

  def admins
    Spree::Role.find_by_name('admin').users
  end

  def set_roles
    unless spree_current_user.has_spree_role? :manager or spree_current_user.has_spree_role? :finance
      flash[:error] = 'Authorization Failure'
      redirect_to forbidden_path
    end
  end

  def set_order
    @order = Spree::Order.includes(:adjustments).find_by!(number: params[:order_id])
  end
end
