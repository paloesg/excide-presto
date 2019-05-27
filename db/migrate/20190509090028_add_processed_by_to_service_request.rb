class AddProcessedByToServiceRequest < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_service_requests, :processed_by, foreign_key: { to_table: :spree_users }
  end
end
