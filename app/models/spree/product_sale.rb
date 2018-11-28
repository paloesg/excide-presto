class Spree::ProductSale < Spree::Base
  belongs_to :variant
  belongs_to :store
end
