require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context "association" do
    it { should belong_to(:customer) }
  end

  context "after create callbacks" do
    let(:vendor) { create(:vendor) }

    it { expect(vendor).to callback(:create_info_record).after(:create) }
  end

  context "delegate" do
    it { should delegate_method(:name).to(:customer).with_prefix(true) }
  end
end
