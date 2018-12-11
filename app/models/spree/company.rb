class Spree::Company < ApplicationRecord
  has_many  :departments
  has_many :users
  has_one :store
  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
end
