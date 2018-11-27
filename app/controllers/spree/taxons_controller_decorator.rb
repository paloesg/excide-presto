Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon
    @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
    @products = sort_products(@searcher.retrieve_products)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  private

  def sort_products(products)
    if params[:sort] == 'brand_asc'
      products.includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.id asc")
    elsif params[:sort] == 'brand_desc'
      products.includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.id desc")
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