class Spree::Department < Spree::Base
  belongs_to :company
  has_many :department_budgets
  has_many :users
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true
  accepts_nested_attributes_for :department_budgets

  #select budget by date is today
  def department_budget
    self.department_budgets.find_by('start_date < ? AND end_date > ?', Date.today, Date.today)
  end

  def budget
    department_budget.budget
  end

  def budget_used
    department_budget.total_order_price
  end

  def increase_budget_used(budget)
    department_data = Spree::DepartmentBudget.find(department_budget.id)
    department_data.total_order_price = (department_data.total_order_price.present? ? department_data.total_order_price : 0) + budget
    department_data.save
  end

  def decrease_budget_used(budget)
    department_data = Spree::DepartmentBudget.find(department_budget.id)
    department_data.total_order_price = (department_data.total_order_price.present? ? department_data.total_order_price : 0) - budget
    department_data.save
  end

  def remaining_budget
    budget - budget_used
  end
end
