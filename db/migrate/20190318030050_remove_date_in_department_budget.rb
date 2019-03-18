class RemoveDateInDepartmentBudget < ActiveRecord::Migration[5.2]
  def change
    remove_column :spree_department_budgets, :start_date, :timestamp
    remove_column :spree_department_budgets, :end_date, :timestamp
    rename_column :spree_department_budgets, :total_order_price, :budget_used
  end
end
