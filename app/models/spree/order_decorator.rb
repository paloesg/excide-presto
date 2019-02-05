Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :preview
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :awaiting_approval
  end

  def self.department(current_user)
    self.joins(:user).where('spree_users.department_id': current_user.department_id)
  end

  def awaiting_approval?
    state.eql? 'awaiting_approval'
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
end