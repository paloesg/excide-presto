module Spree
  module Admin
    class DepartmentsController < ResourceController
      before_action :set_department, only: [:edit, :update, :show, :managers]
      before_action :set_company, only: [:index, :new, :edit, :show, :managers]
      before_action :set_departments, only: [:index]

      def index
      end

      def new
        @department = Spree::Department.new
      end

      def edit
      end

      def create
        @department = Spree::Department.new(department_params)
        if @department.save
          flash[:success] = flash_message_for(@department, :successfully_created)
          redirect_to spree.admin_company_departments_path(@department.company)
        else
          render :new
        end
      end

      def update
        if @department.update_attributes(department_params)
          flash[:success] = Spree.t(:department_updated)
          redirect_to spree.admin_company_departments_path(@department.company)
        else
          render :edit
        end
      end

      def managers
        @managers = @department.roles.find_by(name: 'manager')&.users
      end

      private

      def department_params
        params.require(:department).permit(:name, :company_id, :description, :budget)
      end

      def set_company
        @company = Spree::Company.find(params[:company_id])
      end

      def set_departments
        @departments = Spree::Department.where(company_id: params[:company_id])
      end

      def set_department
        @department = Spree::Department.find(params[:id])
      end
    end
  end
end
