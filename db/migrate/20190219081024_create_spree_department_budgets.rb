class CreateSpreeDepartmentBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_department_budgets, id: :uuid do |t|
      t.string :description
      t.references :department, type: :uuid
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :budget, :precision => 8, :scale => 2
      t.timestamps
    end
  end
end
