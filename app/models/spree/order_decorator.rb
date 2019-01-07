Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :awaiting_approval
  end

  def self.department(current_user)
    self.joins(:user).where('spree_users.department_id': current_user.department_id)
  end

  def awaiting_approval?
    state.eql? 'awaiting_approval'
  end
end