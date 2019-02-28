module Spree
  class DeliveryOrder < Asset
    has_one_attached :attachment
  end
end