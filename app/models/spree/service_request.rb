class Spree::ServiceRequest < Spree::Base
  has_many :files, as: :viewable, dependent: :destroy, class_name: 'Spree::ServiceRequestFile'
end