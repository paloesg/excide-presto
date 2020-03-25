namespace :stores do
  desc "Transfer all products from target store to destination store"
  task :bulk_add_products, [:target_store_id, :destination_store_id] => :environment do |task, args|
    target_store = Spree::Store.find(args[:target_store_id])
    destination_store = Spree::Store.find(args[:destination_store_id])

    puts "You are bulk adding all the products from #{target_store.name} to #{destination_store.name}."

    target_store.products.each do |product|
      if destination_store.products.exists?(product.id)
        puts "Skipping #{product.name} as it already exists in #{destination_store.name}."
      else
        puts "Adding #{product.name} to #{destination_store.name}."
        destination_store.products << product
      end
    end
  end
end
