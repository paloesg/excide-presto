require 'rails_helper'

RSpec.describe Spree::User, type: :model do
  it { should validate_presence_of(:email) }
end
