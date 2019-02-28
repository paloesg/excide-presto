class AddAwaitingApprovalAtToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :awaiting_approval_at, :datetime
  end
end
