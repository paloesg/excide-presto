module Spree
  module Admin
    class ServiceRequestsController < ResourceController
      def index
        @service_requests = Spree::ServiceRequest.all
      end

      def show
        @service_request = Spree::ServiceRequest.find(params[:id])
      end
    end
  end
end