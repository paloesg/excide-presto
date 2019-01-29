module Spree
  module Admin
    class ServicesController < ResourceController

      def index
        @services = Spree::Service.all
      end

      def create
        @service = Service.new(service_params)
        @service.save
        if @service.save
          flash[:success] = flash_message_for(@service, :successfully_created)
        else
          flash[:error] = Spree.t(:could_not_create_product_sale)
        end
      end

      def edit
      end

      def update
        if params[:taxon_ids].present?
          params[:taxon_ids] = params[:taxon_ids].split(',')
        end
        @service = Service.find(params['id'])
        if @service.update(service_params)
          flash[:success] = flash_message_for(@service, :successfully_updated)
        else
          flash[:error] = Spree.t(:could_not_create_product_sale)
        end
      end

      private

      def service_params
        params.permit(:name, :fields, taxon_ids: [])
      end
    end
  end
end