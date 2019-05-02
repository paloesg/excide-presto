class AddStatusToServiceReuests < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_service_requests, :status, :string, default: "unread"
    add_column :spree_service_requests, :updated_by, :integer
  end
end
