class AddCompanyToStores < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_stores, :company_id, :integer
  end
end
