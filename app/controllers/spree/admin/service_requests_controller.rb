module Spree
  module Admin
    class ServiceRequestsController < ResourceController
      def index
        @service_requests = Spree::ServiceRequest.order("created_at ASC").page params[:page]
      end

      def show
        @service_request = Spree::ServiceRequest.find(params[:id])
      end
    end
  end
end