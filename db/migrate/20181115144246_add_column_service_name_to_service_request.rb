class AddColumnServiceNameToServiceRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_service_requests, :service_name, :string
  end
end
