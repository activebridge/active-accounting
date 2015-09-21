require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { is_expected.to have_many(:vendors) }

  context "after create callbacks" do
    let(:customer) { create(:customer) }

    it { expect(customer).to callback(:create_info_record).after(:create) }
  end

  context "delegate" do
    it { is_expected.to delegate_method(:repr_name).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:name).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:address).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:invoice_id).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:agreement_number).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:title_en).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:title_ua).to(:client_info).with_prefix(true) }
    it { is_expected.to delegate_method(:agreement_date).to(:client_info).with_prefix(true) }
  end
end
