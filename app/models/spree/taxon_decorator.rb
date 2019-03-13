Spree::Taxon.class_eval do
  has_one :hero, as: :viewable, dependent: :destroy, class_name: 'Spree::TaxonHero'
  has_many :services_taxons
  has_many :services, through: :services_taxons
end