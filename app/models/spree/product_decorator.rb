Spree::Product.class_eval do
  
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
  end

  def sale(current_store_id)
    sale = self.master.product_sales.find_by(store_id: current_store_id)
    @sale_price = sale.sale_price if sale
  end

end