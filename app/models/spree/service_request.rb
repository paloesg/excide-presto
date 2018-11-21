class Spree::ServiceRequest < Spree::Base
  has_many :images, as: :viewable, dependent: :destroy, class_name: 'Spree::ServiceRequestImage'
end