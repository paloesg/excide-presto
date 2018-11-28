Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon
    @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
    @products = @searcher.retrieve_products
    @products = sort_products(@products)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  private

  def sort_products(products)
    if params[:sort] == 'brand_asc'
      products.sort_by{|p| p.taxons.find{|t| t.taxonomy.name == 'Brands'}.name}
    elsif params[:sort] == 'brand_desc'
      products.sort_by{|p| p.taxons.find{|t| t.taxonomy.name == 'Brands'}.name}.reverse!
    elsif params[:sort] == 'price_asc'
      products.reorder('').send(:ascend_by_master_price)
    elsif params[:sort] == 'price_desc'
      products.reorder('').send(:descend_by_master_price)
    elsif params[:sort] == 'name_asc'
      products.reorder('').send(:ascend_by_name)
    elsif params[:sort] == 'name_desc'
      products.reorder('').send(:descend_by_name)
    else
      products
    end
  end
end