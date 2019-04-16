class Spree::Department < Spree::Base
  belongs_to :company
  has_many :users
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true

  def budget_used
    budget_used = Spree::Order.includes(:user).where(spree_orders: {state: 'complete'} ).where(spree_users: {department_id: self.id}).where('spree_orders.approved_at > ? AND spree_orders.approved_at < ?', Time.current.beginning_of_month, Time.current.end_of_month).sum(:total)
    budget_used || 0
  end

  def remaining_budget
    (budget || 0) - budget_used
  end

  def temp_budget_used(order_id)
    temp_budget_used = Spree::Order.find(order_id).total
    temp_budget_used || 0
  end

  def temp_remaining_budget(order = nil)
    remaining_budget - (order.present? ? temp_budget_used(order.id) : 0)
  end
end
