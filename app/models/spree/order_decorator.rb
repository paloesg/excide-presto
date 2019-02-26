Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :preview
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :awaiting_approval
    go_to_state :rejected
    go_to_state :complete
  end

  before_validation :clone_company_address, if: :use_company_address?
  attr_accessor :use_company_address

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

  # Override checkout_steps from spree file, remove "always append complete steps"
  # 3.6.5 spree/core/app/models/spree/order/checkout.rb
  def checkout_steps
    steps = (self.class.checkout_steps.each_with_object([]) do |(step, options), checkout_steps|
      next if options.include?(:if) && !options[:if].call(self)
      checkout_steps << step
    end).map(&:to_s)
    steps
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

  def use_company_address?
    use_company_address.in?([true, 'true', '1'])
  end

  #to check is the bill address same with company address
  def billing_address_eq_company_address?
    company = self.user.company
    bill_address == company.company_address
  end

  # create bill address clone by company
  def clone_company_address
    company = self.user.company
    if company.company_address && bill_address.nil?
      self.bill_address = company.company_address.clone
    else
      bill_address.attributes = company.company_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end

end