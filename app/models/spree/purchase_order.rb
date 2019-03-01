module Spree
  class PurchaseOrder < Asset
    has_one_attached :attachment
  end
end