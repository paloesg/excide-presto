class CreateSpreeProductSales < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_product_sales, id: :uuid do |t|
      t.decimal :sale_price, precision: 8, scale: 2
      t.string :description
      t.integer :variant_id
      t.integer :store_id
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
      t.timestamps
    end
  end
end
