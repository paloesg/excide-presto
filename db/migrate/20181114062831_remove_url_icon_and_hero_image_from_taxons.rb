class RemoveUrlIconAndHeroImageFromTaxons < ActiveRecord::Migration[5.2]
  def change
    remove_column :spree_taxons, :url_icon_image, :string
    remove_column :spree_taxons, :url_hero_image, :string
  end
end
