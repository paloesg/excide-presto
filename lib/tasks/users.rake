namespace :users do
  desc "set all existing users as approved"
  task :approve_existing => :environment do
    Spree::User.all.each do |user|
      user.approved = true
      user.save
    end
  end
end