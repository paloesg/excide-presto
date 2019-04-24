Spree::Order.class_eval do
  has_one :purchase_order, as: :viewable, dependent: :destroy, class_name: 'Spree::PurchaseOrder'
  has_one :delivery_order, as: :viewable, dependent: :destroy, class_name: 'Spree::DeliveryOrder'
  has_one :invoice, as: :viewable, dependent: :destroy, class_name: 'Spree::Invoice'

  SHIPMENT_STATES = %w(backorder canceled partial pending ready shipped delivered)

  checkout_flow do
    go_to_state :address
    go_to_state :delivery
    go_to_state :preview
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :awaiting_approval
    go_to_state :rejected
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end

  # With method user_class, it can still use another extension or already-established User classes
  if Spree.user_class
    belongs_to :rejector, class_name: Spree.user_class.to_s, optional: true
  else
    belongs_to :rejector, optional: true
  end

  # Update order state and approved by user
  def completed_by(user)
    approved_by(user)
    update_columns(state: 'complete', updated_at: Time.current)
  end

  # Update order state and rejected by user
  def rejected_by(user)
    transaction do
      rejected!
      update_columns(
        rejector_id: user.id,
        rejected_at: Time.current
      )
    end
  end

  def rejected?
    !!rejected_at
  end

  def can_reject?
    !rejected?
  end

  def rejected!
    update_column(:state, 'rejected')
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

  def confirmed?
    state.eql? 'confirm'
  end

  def can_approved?
    budget = self.user.department.budget
    budget_used = self.user.department.budget_used
    current_total = self.total

    return true if budget - (current_total + budget_used) >= 0
  end

  # Override checkout_steps from spree file, remove "always append complete steps"
  # 3.6.5 spree/core/app/models/spree/order/checkout.rb
  def checkout_steps
    steps = (self.class.checkout_steps.each_with_object([]) do |(step, options), checkout_steps|
      next if options.include?(:if) && !options[:if].call(self)
      checkout_steps << step
    end).map(&:to_s)
    steps
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