module Spree
  module Admin
    class DepartmentsController < ResourceController
      def index
      end

      def new
        @deparment = Spree::Department.new
        @companies = Spree::Company.all
      end

      def create
        @department = Spree::Department.new(department_params)
        if @department.save
          flash[:success] = flash_message_for(@department, :successfully_created)
          redirect_to admin_departments_path
        else
          render :new
        end
      end

      def edit
        @department = Spree::Department.find(params[:id])
        @companies = Spree::Company.all
      end

      def update
        @department = Spree::Department.find(params[:id])
        if @department.update_attributes(department_params)
          flash[:success] = Spree.t(:department_updated)
          redirect_to admin_departments_path
        else
          render :edit
        end
      end

      def department_params
        params.require(:department).permit(:name, :company_id, :description)
      end
    end
  end
end
