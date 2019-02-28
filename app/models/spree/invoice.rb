module Spree
  class Invoice < Asset
    has_one_attached :attachment
  end
end