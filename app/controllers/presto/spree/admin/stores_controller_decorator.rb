module Presto
  module Spree
    module Admin
      module StoresControllerDecorator
        def self.prepended(base)
          base.before_action :set_companies
        end

        def new
        end

        def edit
        end

        private
        def set_companies
          @companies = ::Spree::Company.all
        end

      end
    end
  end
end

::Spree::Admin::StoresController.prepend Presto::Spree::Admin::StoresControllerDecorator