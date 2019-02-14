Spree::OrderUpdater.class_eval do
  def update_attributes_and_order(params = {})
    if update_attributes params
      if params.key? :selected_shipping_rate_id
        # Changing the selected Shipping Rate won't update the cost (for now)
        # so we persist the Shipment#cost before calculating order shipment
        # total and updating payment state (given a change in shipment cost
        # might change the Order#payment_state)
        # update_amounts

        # order.updater.update_shipment_total
        # order.updater.update_payment_state

        # Update shipment state only after order total is updated because it
        # (via Order#paid?) affects the shipment state (YAY)
        update_columns(
          state: determine_state(order),
          updated_at: Time.current
        )

        # And then it's time to update shipment states and finally persist
        # order changes
        order.updater.update_shipment_state
        order.updater.persist_totals
      end

      true
    end
  end
end