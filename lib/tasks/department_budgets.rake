namespace :department_budgets do
  desc "Reset department budget monthly"
  task reset_budget: :environment do
    if (Date.today == Date.today.at_beginning_of_month)
      Spree::DepartmentBudget.all.each do |department_budget|
        department_budget.budget_used = 0
        department_budget.save
      end
    end
  end
end
