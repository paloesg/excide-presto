Spree::Order.class_eval do

  SHIPMENT_STATES = %w(backorder canceled partial pending ready shipped delivered)

  checkout_flow do
    go_to_state :address
    go_to_state :delivery
    go_to_state :preview
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :awaiting_approval
    go_to_state :rejected
    go_to_state :complete
  end

  # Update order state and approved by user
  def completed_by(user)
    approved_by(user)
    update_columns(state: 'complete', updated_at: Time.current)
  end

  # Update order state and canceled by user
  def rejected_by(user)
    canceled_by(user)
    update_columns(state: 'rejected', updated_at: Time.current)
  end

  # select all orders where users department same with current user department
  def self.department(current_user)
    self.joins(:user).where('spree_users.department_id': current_user.department_id)
  end

  def awaiting_approval?
    state.eql? 'awaiting_approval'
  end

  def rejected?
    state.eql? 'rejected'
  end

  def delivered?
    %w(partial delivered).include?(shipment_state)
  end

  def select_default_shipping
    create_proposed_shipments
    shipments.find_each &:update_amounts
    update_totals
  end

  # Override spree send email to fix not send who is canceler and send email twice
  def send_cancel_email
  end

  # Override spree method finalize!, remove send email method deliver_order_confirmation_email
  # spree/core/app/models/spree/order.rb
  def finalize!
    all_adjustments.each(&:close)
    updater.update_payment_state
    shipments.each do |shipment|
      shipment.update!(self)
      shipment.finalize!
    end
    updater.update_shipment_state
    save!
    updater.run_hooks
    touch :completed_at
    consider_risk
  end

  def deliver_order_confirmation_email
    Spree::OrderMailer.order_confirmation(id).deliver_later
    update_column(:confirmation_delivered, true)
  end
end