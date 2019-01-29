class Spree::Service < Spree::Base
  has_many :services_taxons
  has_many :taxons, through: :services_taxons
end
