module Presto
  module Spree
    module TaxonDecorator
      def self.prepended(base)
        base.has_one :hero, as: :viewable, dependent: :destroy, class_name: 'Spree::TaxonHero'
        base.has_many :services_taxons
        base.has_many :services, through: :services_taxons
      end
    end
  end
end

::Spree::Taxon.prepend Presto::Spree::TaxonDecorator