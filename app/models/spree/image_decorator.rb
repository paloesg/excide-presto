Spree::Image.class_eval do
  # In Rails 5.x class constants are being undefined/redefined during the code reloading process
  # in a rails development environment, after which the actual ruby objects stored in those class constants
  # are no longer equal (subclass == self) what causes error ActiveRecord::SubclassNotFound
  # Invalid single-table inheritance type: Spree::Image is not a subclass of Spree::Image.
  # The line below prevents the error.
  self.inheritance_column = nil
end