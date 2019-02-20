module Spree
  module Admin
    class DepartmentBudgetsController < ResourceController
      before_action :set_department, only: [:index, :new, :edit]
      before_action :set_company, only: [:index, :new, :edit, :show]
      before_action :set_department_budgets, only: [:index]

      def create
        @department_budget = Spree::DepartmentBudget.new(department_budget_params)
        if @department_budget.save
          flash[:success] = flash_message_for(@department_budget, :successfully_created)
          redirect_to spree.admin_company_department_department_budgets_path(company_id: params["company_id"], department_id: params["department_id"])
        else
          render :new
        end
      end

      def update
        if @department_budget.update_attributes(department_budget_params)
          flash[:success] = Spree.t(:department_budget_updated)
          redirect_to spree.admin_company_department_department_budgets_path(company_id: params["company_id"], department_id: params["department_id"])
        else
          render :edit
        end
      end

      private

      def department_budget_params
        params.require(:department_budget).permit(:description, :start_date, :end_date, :budget, :department_id)
      end

      def set_company
        @company = Spree::Company.find(params[:company_id])
      end

      def set_department_budgets
        @department_budgets = Spree::DepartmentBudget.where(department_id: params[:department_id])
      end

      def set_department
        @department = Spree::Department.find(params[:department_id])
      end
    end
  end
end