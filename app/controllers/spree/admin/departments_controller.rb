module Spree
  module Admin
    class DepartmentsController < ResourceController
      before_action :set_company, only: [:edit, :update]
      before_action :set_companies, only: [:new, :edit]

      def index
      end

      def new
        @deparment = Spree::Department.new
      end

      def create
        @department = Spree::Department.new(department_params)
        if @department.save
          flash[:success] = flash_message_for(@department, :successfully_created)
          redirect_to admin_departments_path
        else
          set_companies
          render :new
        end
      end

      def edit
      end

      def update
        if @department.update_attributes(department_params)
          flash[:success] = Spree.t(:department_updated)
          redirect_to admin_departments_path
        else
          render :edit
        end
      end

      private

      def department_params
        params.require(:department).permit(:name, :company_id, :description)
      end

      def set_company
        @department = Spree::Department.find(params[:id])
      end

      def set_companies
        @companies = Spree::Company.all
      end
    end
  end
end
