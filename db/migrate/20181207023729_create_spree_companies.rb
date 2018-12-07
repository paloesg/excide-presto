class CreateSpreeCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_companies, id: :uuid do |t|
      t.string :name
      t.string :address
      t.string :description

      t.timestamps
    end
  end
end
