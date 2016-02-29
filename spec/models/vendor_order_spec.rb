require 'rails_helper'

RSpec.describe VendorOrder, type: :model do
  context 'association' do
    it { is_expected.to have_many(:order_features) }
    it { is_expected.to have_many(:features) }
    it { is_expected.to belong_to(:vendor) }
  end

  context 'validates' do
    context 'month_uniqueness' do
      let(:vendor) { FactoryGirl.create(:vendor, monthly_payment: true, value_payment: 15) }
      let(:customer) { FactoryGirl.create(:customer) }
      let(:hour) { FactoryGirl.create(:hour, vendor_id: vendor.id, customer_id: customer.id) }
      let!(:vendor_info) { vendor.vendor_info.update(FactoryGirl.attributes_for(:vendor_info)) }
      subject { described_class.create(vendor_id: vendor.id, month: hour.month) }

      context 'with invalid data' do
        let!(:vendor_order) { FactoryGirl.create(:vendor_order, vendor_id: vendor.id, month: hour.month) }

        it { is_expected.to have(1).errors_on(:month) }
      end

      context 'with valid data' do
        it { is_expected.not_to have(1).errors_on(:month) }
      end
    end
  end
end
