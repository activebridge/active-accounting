require 'rails_helper'

RSpec.describe Feature, :type => :model do
  context "association" do
    it { should have_many(:order_features) }
  end

  context "validation rules" do
    it { should validate_presence_of(:name) }
    it { should_not allow_value('').for(:name) }
  end
end
