Spree::Admin::RolesController.class_eval do
  before_action :set_companies, only: [:index, :new, :edit]

  def create
    @role = Spree::Role.new(role_params)
    if @role.save
      flash[:success] = flash_message_for(@role, :successfully_created)
      redirect_to admin_roles_path
    else
      set_companies
      render :new
    end
  end

  private

    def role_params
      params.require(:role).permit(:name, :company_id)
    end

    def set_companies
      @companies = Spree::Company.all
    end
end