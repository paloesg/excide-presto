class CreateSpreeServicesTaxons < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_services_taxons, id: :uuid do |t|
      t.references :service, type: :uuid, null: false, index: true
      t.references :taxon, type: :integer, null: false, index: true
      t.timestamps
    end
  end
end
