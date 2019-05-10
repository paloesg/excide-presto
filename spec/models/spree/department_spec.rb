require 'rails_helper'

RSpec.describe Spree::Department, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:company) }

  it { should belong_to(:company) }
end
