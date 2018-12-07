class Spree::Company < ApplicationRecord
  has_many  :departments
  has_many :users
  has_one :store
end
