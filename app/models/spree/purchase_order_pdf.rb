module Spree
  class PurchaseOrderPdf < Asset
    has_one_attached :attachment
  end
end