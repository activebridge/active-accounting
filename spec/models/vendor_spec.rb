require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context 'associations' do
    it { is_expected.to have_one(:vendor_info).dependent(:destroy) }
    it { is_expected.to have_many(:counterparties).through(:registers) }
    it { is_expected.to have_many(:hours) }
    it { is_expected.to have_many(:registers).dependent(:destroy) }
    it { is_expected.to have_many(:vacations).dependent(:destroy) }
    it { is_expected.to have_many(:vendor_acts).dependent(:destroy) }
    it { is_expected.to have_many(:vendor_orders).dependent(:destroy) }
  end

  context 'after create callbacks' do
    let(:vendor) { create(:vendor) }

    it { expect(vendor).to callback(:create_info_record).after(:create) }
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
