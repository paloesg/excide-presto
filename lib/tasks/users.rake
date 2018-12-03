namespace :users do
  desc "set existing user approved is true"
  task :set_approved => :environment do
    Spree::User.all.each do |user|
      user.approved = true
      user.save
    end
  end
end