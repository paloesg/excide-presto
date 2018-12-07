class AddCompanyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :company_id, :integer
    add_column :spree_users, :department_id, :integer
  end
end
