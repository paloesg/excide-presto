Spree::OrderUpdater.class_eval do
  def update_shipment_state
    if order.backordered?
      order.shipment_state = 'backorder'
    else
      # get all the shipment states for this order
      shipment_states = shipments.states
      order.shipment_state = if shipment_states.size > 1
        # multiple shiment states means it's most likely partially shipped
                               'partial'
                             else
        # will return nil if no shipments are found
                               'ready'
        # TODO: inventory unit states?
        # if order.shipment_state && order.inventory_units.where(shipment_id: nil).exists?
        #   shipments exist but there are unassigned inventory units
        #   order.shipment_state = 'partial'
        # end
                             end
    end

    order.state_changed('shipment')
    order.shipment_state
  end

  def update_payment_state
    last_state = order.payment_state
    order.payment_state = 'paid'
    order.state_changed('shipment')
    order.payment_state
  end
end