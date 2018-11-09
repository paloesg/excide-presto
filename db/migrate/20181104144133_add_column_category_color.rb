class AddColumnCategoryColor < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_taxons, :color, :string
  end
end
