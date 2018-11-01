Spree::Product.class_eval do
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first.name
  end
end