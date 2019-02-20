class ChangeColumnNameInCompanies < ActiveRecord::Migration[5.2]
  def change
    rename_column :spree_companies, :default_currency, :limit_order_price
  end
end
