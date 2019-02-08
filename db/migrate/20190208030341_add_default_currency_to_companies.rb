class AddDefaultCurrencyToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_companies, :default_currency, :string
  end
end
