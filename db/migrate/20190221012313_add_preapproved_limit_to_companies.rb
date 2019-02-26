class AddPreapprovedLimitToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_companies, :preapproved_limit, :decimal, precision: 10, scale: 2
  end
end
