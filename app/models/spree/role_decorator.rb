Spree::Role.class_eval do
  belongs_to :company
  _validators.delete(:name)

  _validate_callbacks.each do |callback|
    if callback.raw_filter.respond_to? :attributes
      callback.raw_filter.attributes.delete :name
    end
  end

end