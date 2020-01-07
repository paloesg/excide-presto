module Presto
  module Spree
    module ProductDecorator
      def brand
        self.taxons.select { |taxon| taxon.taxonomy.name == 'Brands' }.first&.name
      end

      def self.in_taxons_by_brands(taxon)
        self.in_taxons(taxon.id).includes(:taxons).where(spree_taxons: {taxonomy_id: Spree::Taxonomy.find_by(name: 'Brands').id})
      end

      def sold_out?
        self.total_on_hand == 0 && self.master.is_backorderable? == false
      end

      def sale(store_id = nil)
        current_store_id = store_id ? store_id : Spree::Store.current.id
        product_sale = self.master.product_sales.find_by(store_id: current_store_id)
        product_sale.sale_price if product_sale
      end

    end
  end
end