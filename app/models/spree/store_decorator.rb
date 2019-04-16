Spree::Store.class_eval do
  belongs_to  :company
  validates :default_currency, presence: true
end