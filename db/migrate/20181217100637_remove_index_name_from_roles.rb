class RemoveIndexNameFromRoles < ActiveRecord::Migration[5.2]
  def up
    remove_index :spree_roles, name: 'index_spree_roles_on_lower_name'
  end

  def down
    add_index :spree_roles, name: 'index_spree_roles_on_lower_name'
  end
end
