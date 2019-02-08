Spree::Role.class_eval do
  belongs_to :company
  _validators.delete(:name)

  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :name
    end
  end

  def self.get_manager_by_department(company_id, departement_id)
    Spree::Role.find_by(name: 'manager', company_id: company_id)&.users&.where('department_id': departement_id)
  end

end