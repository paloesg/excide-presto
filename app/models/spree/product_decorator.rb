Spree::Product.class_eval do
  
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
  end

  def self.in_taxons_by_brands(taxon)
    self.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id})
  end
  
  def sale
    store = Spree::Store.current
    current_store_id = store.id
    product_sale = self.master.product_sales.find_by(store_id: current_store_id)
    product_sale.sale_price if product_sale
  end
  
end