class CreateSpreeDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_departments, id: :uuid do |t|
      t.string :name
      t.string :description
      t.integer :company_id

      t.timestamps
    end
  end
end
