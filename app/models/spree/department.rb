class Spree::Department < ApplicationRecord
  belongs_to :company
  has_many :users
  validates :name, presence: true
  validates :description, presence: true
end