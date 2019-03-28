class AddRejectedByToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :rejector_id, :integer
    add_column :spree_orders, :rejected_at, :datetime
    add_index :spree_orders, :rejector_id
  end
end
