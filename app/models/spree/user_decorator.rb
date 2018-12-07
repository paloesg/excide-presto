Spree::User.class_eval do
  belongs_to  :company
  belongs_to  :department
end