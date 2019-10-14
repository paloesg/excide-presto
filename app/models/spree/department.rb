class Spree::Department < Spree::Base
  belongs_to :company
  has_many :users
  has_many :roles
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true

  after_create :create_manager

  def budget_used
    #calculate total who have status awaiting approval and updated_at in current month
    budget_awaiting_approval= Spree::Order.includes(:user).where(spree_orders: {state: 'awaiting_approval'} ).where(spree_users: {department_id: self.id}).where('spree_orders.updated_at > ? AND spree_orders.updated_at < ?', Time.current.beginning_of_month, Time.current.end_of_month).sum(:total)

    #calculate total who have status completed and approved_at in current month
    budget_completed = Spree::Order.includes(:user).where(spree_orders: {state: 'complete'} ).where(spree_users: {department_id: self.id}).where('spree_orders.approved_at > ? AND spree_orders.approved_at < ?', Time.current.beginning_of_month, Time.current.end_of_month).sum(:total)

    #calculate total awaiting approval and total completed
    budget_used = budget_awaiting_approval + budget_completed
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

  private

  def create_manager
    role = Spree::Role.new(name: 'manager', company_id: self.company_id, department_id: self.id)
    role.save
  end
end
