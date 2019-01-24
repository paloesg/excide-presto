class AddAddressRefToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_companies, :address, type: :integer
    remove_column :spree_companies, :address, :string
  end
end
