class AddBudgetToDepartment < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_departments, :budget, :decimal, :precision => 10, :scale => 2
  end
end
