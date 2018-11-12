Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
  end
end