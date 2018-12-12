Spree::UsersController.class_eval do
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :company_name, :phone, :passwod)
  end
end