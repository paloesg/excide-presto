class Spree::ProductSale < Spree::Base
  belongs_to :variant
  belongs_to :store

  with_options presence: true do
    validates :sale_price, :variant_id, :store_id
  end

  validates_uniqueness_of :variant_id, :scope => :store_id, :message => 'is already an existing sale price set for this store. Please remove it to add a new sale price.'
end
