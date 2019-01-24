class AddCompanyToStores < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_stores, :company, type: :uuid
  end
end
