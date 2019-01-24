class Spree::ServiceRequest < Spree::Base
  paginates_per 10
  has_many :files, as: :viewable, dependent: :destroy, class_name: 'Spree::ServiceRequestFile'
  belongs_to :user
end