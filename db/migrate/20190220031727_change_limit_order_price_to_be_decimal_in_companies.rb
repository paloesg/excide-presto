class ChangeLimitOrderPriceToBeDecimalInCompanies < ActiveRecord::Migration[5.2]
  def up
    change_column :spree_companies, :limit_order_price, 'numeric(10,2) USING CAST(limit_order_price AS numeric(10,2))'
  end

  def down
    change_column :spree_companies, :limit_order_price, :string
  end
end
