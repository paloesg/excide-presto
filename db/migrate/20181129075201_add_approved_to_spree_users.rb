class AddApprovedToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :approved, :boolean, :default => false, :null => false
  end
end
