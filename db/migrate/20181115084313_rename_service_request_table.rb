class RenameServiceRequestTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :service_requests, :spree_service_requests
  end
end
