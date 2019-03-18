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
    budget_used = Spree::Order.includes(:user).where(spree_users: {department_id: self.id}).where('spree_orders.created_at > ? AND spree_orders.created_at < ?', Time.now.beginning_of_month, Time.now.end_of_month).where.not(state: 'rejected').sum(:total)
    budget_used.present? ? budget_used : 0
  end

  def remaining_budget
    budget - budget_used
  end
end
