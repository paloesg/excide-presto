class Spree::Company < Spree::Base
  has_many  :departments
  has_many :users
  has_one :store
  has_one :role
  belongs_to :company_address, foreign_key: :address_id, class_name: 'Spree::Address',
                                optional: true
  validates :name, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :company_address
end
