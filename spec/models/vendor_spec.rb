require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:vendor_acts) }
  end

  context 'after create callbacks' do
    let(:vendor) { create(:vendor) }

    it { expect(vendor).to callback(:create_info_record).after(:create) }
  end

  context 'delegate' do
    it { is_expected.to delegate_method(:name).to(:customer).with_prefix(true) }
  end

  describe 'scope' do
    context '.by_missing_hours' do
      context 'should include vendor' do
        let!(:vendor) { create(:vendor) }
        it { expect(Vendor.by_missing_hours).to include(vendor) }
      end

      context 'should not include vendor' do
        let(:customer) { FactoryGirl.create(:customer) }
        let(:vendor) { FactoryGirl.create(:vendor, customer_id: customer.id, approve_hours: true) }
        let!(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }

        it { expect(Vendor.by_missing_hours).to_not include(vendor) }
      end
    end
  end
end
