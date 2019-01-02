class CreateSpreeServices < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_services, id: :uuid do |t|
      t.string :name
      t.json :fields, default: '[]'
      t.timestamps
    end
  end
end
