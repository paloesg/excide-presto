Spree::Admin::RolesController.class_eval do
  before_action :set_companies, only: [:index, :new, :edit]
  before_action :set_company, only: [:index, :new, :edit, :users]
  before_action :set_roles, only: [:index]
  before_action :set_role, only: [:edit, :show, :users]

  def create
    @role = Spree::Role.new(role_params)
    if @role.save
      flash[:success] = flash_message_for(@role, :successfully_created)
      if params[:role][:company_id].present?
        redirect_to spree.admin_company_roles_path(@role.company)
      else
        redirect_to admin_roles_path
      end
    else
      set_companies
      render :new
    end
  end

  def update
    if @role.update_attributes(role_params)
      flash[:success] = Spree.t(:role_updated)
      if params[:role][:company_id].present?
        redirect_to spree.admin_company_roles_path(@role.company)
      else
        redirect_to admin_roles_path
      end
    else
      set_companies
      render :edit
    end
  end

  def users
    @role_users = @role.users.page params[:page]
  end

  private

    def role_params
      params.require(:role).permit(:name, :company_id, :department_id)
    end

    def set_companies
      if params[:company_id].present?
        @companies = Spree::Company.where(company_id: params[:company_id])
      else
        @companies = Spree::Company.all
      end
    end

    def set_company
      if params[:company_id].present?
        @company = Spree::Company.find(params[:company_id])
      end
    end

    def set_roles
      if params[:company_id].present?
        @roles = Spree::Role.where(company_id: params[:company_id]).where.not(department_id: nil)
      else
        @roles = Spree::Role.all
      end
    end

    def set_role
      @role = Spree::Role.find(params[:id])
    end
end