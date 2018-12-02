Spree::Admin::UsersController.class_eval do

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
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
                                 [:approved,
                                  :use_billing,
                                  spree_role_ids: [],
                                  ship_address_attributes: permitted_address_attributes,
                                  bill_address_attributes: permitted_address_attributes])
  end

end