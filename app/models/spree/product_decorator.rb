Spree::Product.class_eval do
  
  def brand
    self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
  end

  def sale
    store = Spree::Store.current
    current_store_id = store.id
    product_sale = self.master.product_sales.find_by(store_id: current_store_id)
    product_sale.sale_price if product_sale
  end

end