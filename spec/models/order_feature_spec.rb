require 'rails_helper'

RSpec.describe OrderFeature, :type => :model do
  context "association" do
    it { should belong_to(:vendor_order) }
    it { should belong_to(:feature) }
  end
end
