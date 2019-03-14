class AddSlugToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_services, :slug, :string
    add_column :spree_services, :description, :text
    add_column :spree_services, :meta_title, :string
    add_column :spree_services, :meta_keywords, :string
    add_column :spree_services, :meta_description, :text
  end
end
