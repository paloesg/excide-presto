Spree::TaxonsController.class_eval do
  def show
    @taxon = Spree::Taxon.friendly.find(params[:id])
    return unless @taxon
    @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
    @products = sort_products(@searcher.retrieve_products, @taxon)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  private

  def sort_products(products, taxon)
    if params[:sort] == 'brand_asc'
      Spree::Product.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.name ASC").page(params[:page]).per(12)
    elsif params[:sort] == 'brand_desc'
      Spree::Product.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.name DESC").page(params[:page]).per(12)
    elsif params[:sort] == 'price_asc'
      render json: products.reorder('').send(:ascend_by_master_price).to_json
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