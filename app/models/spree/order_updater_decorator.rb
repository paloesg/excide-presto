Spree::OrderUpdater.class_eval do
  def update
    unless order.shipment_state == 'shipped'
      order.select_default_shipping
    end
    update_item_count
    update_totals
    if order.completed?
      update_payment_state
      update_shipments
      update_shipment_state
      update_shipment_total
    end
    run_hooks
    persist_totals
  end

  def update_payment_state
    last_state = order.payment_state
    if payments.present? && payments.valid.empty?
      order.payment_state = 'failed'
    elsif order.canceled? && order.payment_total == 0
      order.payment_state = 'void'
    else
      order.payment_state = 'paid'
    end
    order.state_changed('payment') if last_state != order.payment_state
    order.payment_state
  end
end