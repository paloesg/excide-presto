class DropDepartmentBudgets < ActiveRecord::Migration[5.2]
  def change
    drop_table :spree_department_budgets
  end
end
