class Spree::Department < Spree::Base
  belongs_to :company
  has_many :users
  validates :name, presence: true
  validates :company, presence: true
  validates :description, presence: true
end