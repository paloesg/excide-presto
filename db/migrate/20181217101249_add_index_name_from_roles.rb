class AddIndexNameFromRoles < ActiveRecord::Migration[5.2]
  def up
    add_index :spree_roles, :name
  end

  def down
    remove_index :spree_roles, name: 'index_spree_roles_on_lower_name'
  end
end
