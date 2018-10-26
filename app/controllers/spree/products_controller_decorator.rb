Spree::ProductsController.class_eval do
  def show_modal
    load_product
    @brand = @product.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first
    render :layout => false
  end
end