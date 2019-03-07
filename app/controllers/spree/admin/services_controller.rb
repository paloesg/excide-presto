module Spree
  module Admin
    class ServicesController < ResourceController

      def index
        @services = Spree::Service.all
      end

      def create
        if params[:taxon_ids].present?
          params[:taxon_ids] = params[:taxon_ids].split(',')
        end
        if params[:name].present?
          params[:slug] = params[:name].parameterize
        end
        @service = Service.new(service_params.except(:icon))
        @service.build_icon(attachment: params[:icon]) if params[:icon]
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
        if params[:name].present?
          params[:slug] = params[:name].parameterize
        end
        @service = Service.find(params['id'])
        @service.create_icon(attachment: service_params[:icon]) if service_params[:icon]
        if @service.update(service_params.except(:icon))
          flash[:success] = flash_message_for(@service, :successfully_updated)
        else
          flash[:error] = Spree.t(:could_not_create_product_sale)
        end
      end

      private

      def service_params
        params.permit(:name, :fields, :description, :slug, :meta_title, :meta_keywords, :meta_description, :icon, taxon_ids: [])
      end
    end
  end
end