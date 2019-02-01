class Spree::Service < Spree::Base
  has_many :services_taxons
  has_many :taxons, through: :services_taxons

  def self.in_taxons_by_services(taxon)
    self.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Services').id})
  end
end
