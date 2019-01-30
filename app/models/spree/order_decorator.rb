Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
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

  def self.department(current_user)
    self.joins(:user).where('spree_users.department_id': current_user.department_id)
  end

  def awaiting_approval?
    state.eql? 'awaiting_approval'
  end

  def rejected?
    state.eql? 'rejected'
  end

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
end