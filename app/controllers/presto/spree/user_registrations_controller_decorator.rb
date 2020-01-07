module Presto
  module Spree
    module UserRegistrationsController
      def self.prepended(base)
        skip_before_action :require_login
      end

      def create
        @user = build_resource(spree_user_params)
        resource_saved = resource.save

        yield resource if block_given?
        if resource_saved
          admin_users = Spree::Role.find_by_name('admin').users
          admin_users.each do |admin|
            UserMailer.registration_email(admin, @user).deliver_later
          end
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up
            sign_up(resource_name, resource)
            session[:spree_user_signup] = true
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords(resource)
          render :new
        end
      end

      def spree_user_params
        params.require(:spree_user).permit([:email, :first_name, :last_name, :remarks, :phone, :password])
      end

    end
  end
end
