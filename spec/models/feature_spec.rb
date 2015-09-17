require 'rails_helper'

RSpec.describe Feature, :type => :model do
  context "association" do
    it { is_expected.to have_many(:order_features) }
  end

  context "validation rules" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.not_to allow_value('').for(:name) }
  end
end
