class Spree::Department < Spree::Base
  belongs_to :company
  has_many :department_budgets
  has_many :users
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true\

  def department_budget
    self.department_budgets.find_by('start_date < ? AND end_date > ?', Date.today, Date.today)
  end
end
