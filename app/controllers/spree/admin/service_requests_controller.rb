module Spree
  module Admin
    class ServiceRequestsController < ResourceController
      before_action :initialize_service_request_events

      def index
        @service_requests = Spree::ServiceRequest.order("created_at DESC").page params[:page]
      end

      def show
        @service_request = Spree::ServiceRequest.find(params[:id])
      end

      def processing
        @service_request.processing!
        @service_request.updated_by(try_spree_current_user)
        flash[:success] = Spree.t(:service_request_processing)
        redirect_back fallback_location: spree.edit_admin_service_request_url(@service_request)
      end

      def complete
        @service_request.completed!
        @service_request.updated_by(try_spree_current_user)
        flash[:success] = Spree.t(:service_request_completed)
        redirect_back fallback_location: spree.edit_admin_service_request_url(@service_request)
      end

      def reject
        @service_request.rejected!
        @service_request.updated_by(try_spree_current_user)
        flash[:success] = Spree.t(:service_request_rejected)
        redirect_back fallback_location: spree.edit_admin_service_request_url(@service_request)
      end

      private

      def initialize_service_request_events
        @service_request_events = %w{processing complete reject}
      end

    end
  end
end