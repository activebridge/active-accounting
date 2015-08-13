require 'rails_helper'

RSpec.describe VendorOrder, :type => :model do
  context "association" do
    it { should have_many(:order_features) }
    it { should have_many(:features) }
    it { should belong_to(:vendor) }
  end
end
