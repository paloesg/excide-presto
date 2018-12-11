module Spree
  module Admin
    class CompaniesController < ResourceController
      def index
        @companies = Spree::Company.all
      end

      def new
        @company = Spree::Company.new
      end

      def create
        @company = Spree::Company.new(company_params)
        if @company.save
          flash[:success] = flash_message_for(@company, :successfully_created)
          redirect_to admin_companies_path
        else
          render :new
        end
      end

      private

      def company_params
        params.require(:company).permit(:name, :address, :description)
      end
    end
  end
end
