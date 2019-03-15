module Spree
  module Admin
    class ServicesController < ResourceController
      before_action :load_service, only: [:edit, :update]

      def index
        @services = Spree::Service.all.page(params[:page]).per(params[:per_page])
      end

      def create
        if service_params[:taxon_ids].present?
          service_params[:taxon_ids] = service_params[:taxon_ids].split(',')
        end
        if service_params[:name].present?
          service_params[:slug] = service_params[:name].parameterize
        end
        @service = Service.new(service_params.except(:icon))
        @service.build_icon(attachment: service_params[:icon]) if service_params[:icon]
        if @service.save
          flash[:success] = flash_message_for(@service, :successfully_created)
          respond_with(@service) do |format|
            format.html { redirect_to admin_services_path }
            format.json { render json: @service.to_json }
          end
        else
          respond_with(@service) do |format|
            format.html { render :edit }
            format.json { render json: @service.errors.full_messages.to_sentence, status: 422 }
          end
        end
      end

      def edit
      end

      def update
        successful = @service.transaction do
          if service_params[:taxon_ids].present?
            service_params[:taxon_ids] = service_params[:taxon_ids].split(',')
          end
          if service_params[:name].present?
            service_params[:slug] = service_params[:name].parameterize
          end
          @service.save!
          @service.create_icon(attachment: service_params[:icon]) if service_params[:icon]
          @service.update(service_params.except(:icon))
        end
        if successful
          flash[:success] = flash_message_for(@service, :successfully_updated)
          respond_with(@service) do |format|
            format.html { redirect_to admin_services_path }
            format.json { render json: @service.to_json }
          end
        else
          respond_with(@service) do |format|
            format.html { render :edit }
            format.json { render json: @service.errors.full_messages.to_sentence, status: 422 }
          end
        end
      end

      private

      def service_params
        params.require(:service).permit(:name, :fields, :description, :slug, :meta_title, :meta_keywords, :meta_description, :icon, taxon_ids: [])
      end

      def load_service
        @service = Spree::Service.find(params[:id])
      end
    end
  end
end