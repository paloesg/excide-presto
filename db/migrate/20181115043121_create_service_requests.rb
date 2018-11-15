class CreateServiceRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :service_requests, id: :uuid do |t|
      t.references :spree_user, index: true, foreign_key: true
      t.json :fields, default: '[]'
      t.timestamps
    end
  end
end
