module Presto
  module Spree
    module TaxonsControllerDecorator
      def show
        @taxon = ::Spree::Taxon.friendly.find(params[:id])
        @services = @taxon.services
        return unless @taxon
        @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
        @products = sort_products(@searcher.retrieve_products, @taxon)
        @taxonomies = ::Spree::Taxonomy.includes(root: :children)
      end

      def taxon_product_partial
        @taxon = ::Spree::Taxon.friendly.find(params[:id])
        return unless @taxon

        @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
        @products = sort_products(@searcher.retrieve_products, @taxon)
        @taxonomies = ::Spree::Taxonomy.includes(root: :children)
        respond_to do |format|
          format.js
        end
      end

      private

      def sort_products(products, taxon)
        products = params[:sort] == 'brand_asc' || params[:sort] == 'brand_desc' ? ::Spree::Store.find(params[:current_store_id]).products.in_taxons_by_brands(taxon) : ::Spree::Store.find(current_store.id).products.in_taxons(taxon.id).includes(:taxons)

        if params[:sort] == 'brand_asc'
          products = products.order("spree_taxons.name ASC")
        elsif params[:sort] == 'brand_desc'
          products = products.order("spree_taxons.name DESC")
        elsif params[:sort] == 'price_asc'
          products = products.reorder('').send(:ascend_by_master_price)
        elsif params[:sort] == 'price_desc'
          products = products.reorder('').send(:descend_by_master_price)
        elsif params[:sort] == 'name_asc'
          products = products.reorder('').send(:ascend_by_name)
        elsif params[:sort] == 'name_desc'
          products = products.reorder('').send(:descend_by_name)
        else
          products = products.distinct
        end
        products.page(params[:page]).per(12)
      end
    end
  end
end

::Spree::TaxonsController.prepend Presto::Spree::TaxonsControllerDecorator