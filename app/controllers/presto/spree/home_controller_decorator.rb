module Presto
  module Spree
    module HomeControllerDecorator
      def self.prepended(base)
        base.before_action :set_categories
      end

      def set_categories
        # Combine products and services
        @categories = ::Spree::Taxonomy.find_by_name('Categories').root.children.take(3) + ::Spree::Taxonomy.find_by_name('Services').root.children.all()
      end
    end
  end
end

::Spree::HomeController.prepend Presto::Spree::HomeControllerDecorator