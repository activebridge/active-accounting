require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:vendors) }

  context "after create callbacks" do
    let(:customer) { create(:customer) }

    it { expect(customer).to callback(:create_info_record).after(:create) }
  end

  context "delegate" do
    it { should delegate_method(:repr_name).to(:client_info).with_prefix(true) }
    it { should delegate_method(:name).to(:client_info).with_prefix(true) }
    it { should delegate_method(:address).to(:client_info).with_prefix(true) }
    it { should delegate_method(:invoice_id).to(:client_info).with_prefix(true) }
    it { should delegate_method(:agreement).to(:client_info).with_prefix(true) }
    it { should delegate_method(:title_en).to(:client_info).with_prefix(true) }
    it { should delegate_method(:title_ua).to(:client_info).with_prefix(true) }
  end
end
