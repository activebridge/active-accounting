require 'rails_helper'

RSpec.describe VendorOrder, :type => :model do
  context "association" do
    it { is_expected.to have_many(:order_features) }
    it { is_expected.to have_many(:features) }
    it { is_expected.to belong_to(:vendor) }
  end
end
