class AddCompanyToRoles < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_roles, :company, type: :uuid
  end
end
