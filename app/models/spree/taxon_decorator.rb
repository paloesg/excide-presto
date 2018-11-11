Spree::Taxon.class_eval do
  has_one :hero, as: :viewable, dependent: :destroy, class_name: 'Spree::TaxonHero'
end