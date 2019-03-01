class AddDeliveredAtToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :delivered_at, :timestamp
  end
end
