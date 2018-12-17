Spree::Admin::UsersController.class_eval do

  def new
    @companies = Spree::Company.all
  end

  def edit
    @companies = Spree::Company.all
    @departments = Spree::Department.where(company_id: @user.company_id)
    @roles = Spree::Role.where(company_id: @user.company_id)
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if params[:user][:approved] == "1" && @user.password_salt.blank?
      @user.send_new_password_instructions(spree_current_user.email)
    end

    if @user.update_attributes(user_params)
      flash[:success] = Spree.t(:account_updated)
      redirect_to edit_admin_user_path(@user)
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(permitted_user_attributes |
                                  [:approved, :first_name, :last_name, :company_name, :phone,
                                  :company_id, :department_id,
                                  :use_billing,
                                  spree_role_ids: [],
                                  ship_address_attributes: permitted_address_attributes,
                                  bill_address_attributes: permitted_address_attributes])
  end

end