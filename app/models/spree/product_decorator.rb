Spree::Product.class_eval do
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
  end

  def self.in_taxons_by_brands(taxon)
    self.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id})
  end
end