module Spree
  class ServiceRequestFile < Asset
    has_one_attached :attachment
  end
end