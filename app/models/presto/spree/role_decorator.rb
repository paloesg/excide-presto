module Presto
  module Spree
    module RoleDecorator
      def self.prepended(base)
        base.belongs_to :company
        base.belongs_to :department
        base._validators.delete(:name)

        base._validate_callbacks.each do |callback|
          if callback.raw_filter.respond_to? :attributes
            callback.raw_filter.attributes.delete :name
          end
        end
      end

      def self.get_manager_by_department(user)
        ::Spree::Role.find_by(name: 'manager', company_id: user.company_id, department_id: user.department_id)&.users
      end

    end
  end
end

::Spree::Role.prepend Presto::Spree::RoleDecorator