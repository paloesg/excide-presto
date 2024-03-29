Spree::UserPasswordsController.class_eval do
  skip_before_action :require_login

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, location: spree.login_path
    else
      respond_with_navigational(resource) { render :new }
    end
  end

end