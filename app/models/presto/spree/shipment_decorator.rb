module Presto
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.scope :pending, -> { with_state('pending') }
        base.scope :ready,   -> { with_state('ready') }
        base.scope :shipped, -> { with_state('shipped') }
        base.scope :delivered, -> { with_state('delivered') }
        base.scope :trackable, -> { where("tracking IS NOT NULL AND tracking != ''") }
        base.scope :with_state, ->(*s) { where(state: s) }
        # sort by most recent shipped_at, falling back to created_at. add "id desc" to make specs that involve this scope more deterministic.
        base.scope :reverse_chronological, -> { order(Arel.sql('coalesce(spree_shipments.shipped_at, spree_shipments.created_at) desc'), id: :desc) }

        # shipment state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
        base.state_machine initial: :pending, use_transactions: false do
          base.event :ready do
            base.transition from: :pending, to: :ready, if: lambda { |shipment|
              # Fix for #2040
              shipment.determine_state(shipment.order) == 'ready'
            }
          end

          base.event :pend do
            transition from: :ready, to: :pending
          end

          base.event :ship do
            transition from: %i(ready canceled), to: :shipped
          end

          base.event :delivery do
            transition from: :shipped, to: :delivered
          end
          # after_transition to: :delivered, do: :after_ship

          base.event :cancel do
            transition to: :canceled, from: %i(pending ready)
          end
          base.after_transition to: :canceled, do: :after_cancel

          base.event :resume do
            transition from: :canceled, to: :ready, if: lambda { |shipment|
              shipment.determine_state(shipment.order) == 'ready'
            }
            transition from: :canceled, to: :pending
          end
          base.after_transition from: :canceled, to: %i(pending ready shipped delivered), do: :after_resume

          base.after_transition do |shipment, transition|
            shipment.state_changes.create!(
              previous_state: transition.from,
              next_state:     transition.to,
              name:           'shipment'
            )
          end
        end
      end

      # Determines the appropriate +state+ according to the following logic:
      #
      # pending    unless order is complete and +order.payment_state+ is +paid+
      # shipped    if already shipped (ie. does not change the state)
      # ready      all other cases
      def determine_state(order)
        return 'canceled' if order.canceled?
        return 'pending' unless order.can_ship?
        return 'pending' if inventory_units.any? &:backordered?
        return 'shipped' if shipped?
        return 'delivered' if delivered?
        order.paid? || Spree::Config[:auto_capture_on_dispatch] ? 'ready' : 'pending'
      end

      def update!(order)
        old_state = state
        new_state = determine_state(order)
        update_columns(
          state: new_state,
          updated_at: Time.current
        )
        after_ship if new_state == 'delivered' && old_state != 'delivered'
      end

      def delivered=(value)
        return unless value == '1' && delivered_at.nil?
        self.delivered_at = Time.current
      end
    end
  end
end