class Spree::Department < ApplicationRecord
  belongs_to :company
  has_many :users
end
`