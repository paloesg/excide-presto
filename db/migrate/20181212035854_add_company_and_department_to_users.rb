class AddCompanyAndDepartmentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_users, :company, type: :uuid
    add_reference :spree_users, :department, type: :uuid
  end
end
