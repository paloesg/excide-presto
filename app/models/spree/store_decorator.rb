Spree::Store.class_eval do
  belongs_to  :company
  validates :company, presence: true
  validates :default_currency, presence: true
end