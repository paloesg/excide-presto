class AddUrlImagesToSpreeTaxons < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_taxons, :url_icon_image, :string
    add_column :spree_taxons, :url_hero_image, :string
  end
end
