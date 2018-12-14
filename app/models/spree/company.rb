class Spree::Company < Spree::Base
  has_many  :departments
  has_many :users
  has_one :store
  has_one :role
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
end
