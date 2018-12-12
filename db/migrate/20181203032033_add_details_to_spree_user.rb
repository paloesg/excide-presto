class AddDetailsToSpreeUser < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :first_name, :string
    add_column :spree_users, :last_name, :string
    add_column :spree_users, :company_name, :string
    add_column :spree_users, :phone, :string
  end
end
