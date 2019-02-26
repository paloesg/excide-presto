Spree::UsersController.class_eval do
  prepend_before_action :load_object, only: [:show, :edit, :update, :password]

  def update
    if params[:user][:password].present?
      if params[:user][:password] == params[:user][:password_confirmation]
        if @user.update_attributes(user_params)
          Spree::User.reset_password_by_token(params[:user])
          if Spree::Auth::Config[:signout_after_password_change]
            sign_in(@user, event: :authentication)
          else
            bypass_sign_in(@user)
          end
          redirect_to spree.account_url, notice: Spree.t(:account_updated)
        else
          render :edit
        end
      else
        flash[:error] = "Your passwords do not match. Please try again."
        redirect_back fallback_location: spree.password_account_path
      end
    else
      if @user.update_attributes(user_params)
        redirect_to spree.account_url, notice: Spree.t(:account_updated)
      else
        render :edit
      end
    end
  end

  def user_company_address
    company_address = spree_current_user.company.company_address
    respond_to do |format|
      format.js { render json: company_address }
    end
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :company_name, :phone, :password, :password_confirmation)
  end
end