class Spree::ProductSale < Spree::Base
  belongs_to :variant
  belongs_to :store

  with_options presence: true do
    validates :sale_price, :variant_id, :store_id
  end
end
