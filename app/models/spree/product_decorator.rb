Spree::Product.class_eval do
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
  end

  def sold_out?
    self.total_on_hand == 0 && self.master.is_backorderable? == false
  end
end