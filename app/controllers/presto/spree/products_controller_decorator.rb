
module Presto
  module Spree
    module ProductsControllerDecorator
      def show_modal
        load_product
        render :layout => false
      end

      def index
        @searcher = build_searcher(params.merge(include_images: true))
        @products = sort_products(@searcher.retrieve_products)
        @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
        @taxonomies = ::Spree::Taxonomy.includes(root: :children)
      end

      def remaining_budget_partial
        respond_to do |format|
          format.js
        end
      end

      def product_partial
        @searcher = build_searcher(params.merge(include_images: true))
        @products = sort_products(@searcher.retrieve_products)
        @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
        @taxonomies = ::Spree::Taxonomy.includes(root: :children)
        respond_to do |format|
          format.js
        end
      end

      private

      def sort_products(products)
        if params[:sort] == 'brand_asc'
          products.includes(:taxons).where(spree_taxons: {taxonomy_id: ::Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.name asc")
        elsif params[:sort] == 'brand_desc'
          products.includes(:taxons).where(spree_taxons: {taxonomy_id: ::Spree::Taxonomy.find_by(name: 'Brands').id}).order("spree_taxons.name desc")
        elsif params[:sort] == 'price_asc'
          products.reorder('').send(:ascend_by_master_price)
        elsif params[:sort] == 'price_desc'
          products.reorder('').send(:descend_by_master_price)
        elsif params[:sort] == 'name_asc'
          products.reorder('').send(:ascend_by_name)
        elsif params[:sort] == 'name_desc'
          products.reorder('').send(:descend_by_name)
        else
          products.distinct
        end
      end
    end
  end
end

::Spree::ProductsController.prepend Presto::Spree::ProductsControllerDecorator