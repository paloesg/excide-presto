module Presto
  module Spree
    module Admin
      module StoresController
        def self.prepended(base)
          before_action :set_companies
        end

        def new
        end

        def edit
        end

        private
        def set_companies
          @companies = Spree::Company.all
        end

      end
    end
  end
end