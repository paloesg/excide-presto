Spree::ProductsController.class_eval do
  def show_modal
    load_product
    render :layout => false
  end

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @products = sort_products(@products)
    @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  private

  def sort_products(products)
    if params[:sort] == 'price_asc'
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