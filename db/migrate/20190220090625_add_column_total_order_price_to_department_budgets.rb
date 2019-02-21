class AddColumnTotalOrderPriceToDepartmentBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_department_budgets, :total_order_price, :decimal, :precision => 10, :scale => 2
  end
end
