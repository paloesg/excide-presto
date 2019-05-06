class AddDepartmentIdToRoles < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_roles, :department, type: :uuid
  end
end
