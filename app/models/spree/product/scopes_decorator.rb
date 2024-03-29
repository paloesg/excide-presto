Spree::Product.class_eval do
  add_search_scope :ascend_by_master_price do
    group(['spree_products.id', 'spree_prices.amount']).joins(master: :default_price).order("#{price_table_name}.amount ASC")
  end

  add_search_scope :descend_by_master_price do
    group(['spree_products.id', 'spree_prices.amount']).joins(master: :default_price).order("#{price_table_name}.amount DESC")
  end

  add_search_scope :ascend_by_name do
    group('spree_products.id').order("name ASC")
  end

  add_search_scope :descend_by_name do
    group('spree_products.id').order("name DESC")
  end

end