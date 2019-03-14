class RenameCompanyNameInUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :spree_users, :company_name, :remarks
  end
end
