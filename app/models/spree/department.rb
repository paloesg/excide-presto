class Spree::Department < Spree::Base
  belongs_to :company
  has_one :department_budget
  has_many :users
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true

  def budget
    department_budget.budget
  end

  def budget_used
    department_budget.budget_used.present? ? department_budget.budget_used : 0
  end

  def increase_budget_used(budget)
    department_data = Spree::DepartmentBudget.find(department_budget.id)
    department_data.budget_used = (department_data.budget_used.present? ? department_data.budget_used : 0) + budget
    department_data.save
  end

  def decrease_budget_used(budget)
    department_data = Spree::DepartmentBudget.find(department_budget.id)
    department_data.budget_used = (department_data.budget_used.present? ? department_data.budget_used : 0) - budget
    department_data.save
  end

  def remaining_budget
    budget - budget_used
  end
end
