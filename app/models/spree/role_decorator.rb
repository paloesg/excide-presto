Spree::Role.class_eval do
  belongs_to :company
  belongs_to :department
  _validators.delete(:name)

  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :name
    end
  end

  def self.get_manager_by_department(user)
    Spree::Role.find_by(name: 'manager', company_id: user.company_id, department_id: user.department_id)&.users
  end

end