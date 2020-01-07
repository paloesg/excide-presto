module Presto
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.belongs_to  :company
        base.validates :company, presence: true
        base.validates :default_currency, presence: true
      end
    end
  end
end