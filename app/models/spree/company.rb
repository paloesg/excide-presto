class Spree::Company < Spree::Base
  has_many  :departments
  has_many :users
  has_one :store
  has_one :role
  belongs_to :company_address, foreign_key: :address_id, class_name: 'Spree::Address', optional: true

  validates :name, presence: true
  validates :description, presence: true

  after_create :create_manager

  accepts_nested_attributes_for :company_address

  private

  def create_manager
    role = Spree::Role.new(name: 'manager', company_id: self.id)
    role.save
  end
end
