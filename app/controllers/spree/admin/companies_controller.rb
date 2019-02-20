module Spree
  module Admin
    class CompaniesController < ResourceController
      before_action :set_company, only: [:edit, :update]
      before_action :set_departments, only: [:users]
      before_action :set_roles, only: [:users]

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

      def edit
      end

      def addresses
        if request.put?
          if @company.update_attributes(company_params)
            flash.now[:success] = Spree.t(:company_updated)
          end
          render :addresses
        end
      end

      def update
        if @company.update_attributes(company_params)
          flash[:success] = Spree.t(:company_updated)
          redirect_to edit_admin_company_path(@company)
        else
          render :edit
        end
      end

      def get_departments
        departments = Spree::Department.where(company_id: params[:company_id])
        respond_to do |format|
          format.js { render json: departments }
        end
      end

      private

      def set_company
        @company = Spree::Company.find(params[:id])
      end

      def set_departments
        @departments = Spree::Department.where(company_id: params[:id])
      end

      def set_roles
        @roles = Spree::Role.where(company_id: params[:id])
      end

      def company_params
        params.require(:company).permit(:name, :address_id, :description, :default_currency, company_address_attributes: permitted_address_attributes)
      end
    end
  end
end
