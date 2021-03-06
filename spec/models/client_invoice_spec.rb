require 'rails_helper'

RSpec.describe ClientInvoice, type: :model do
  before { create(:signature) }

  it_behaves_like 'has signature'

  context 'associations' do
    it { is_expected.to belong_to(:customer) }
  end

  context 'validates' do
    context 'month_uniqueness' do
      let(:vendor) { FactoryGirl.create(:vendor) }
      let(:customer) { FactoryGirl.create(:customer, monthly_payment: true, value_payment: 15) }
      let(:hour) { FactoryGirl.create(:hour, vendor_id: vendor.id, customer_id: customer.id) }
      let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
      subject { described_class.create(customer_id: customer.id, month: hour.month) }

      context 'with invalid data' do
        let!(:client_invoice) { FactoryGirl.create(:client_invoice, customer_id: customer.id, month: hour.month) }

        it { is_expected.to have(1).errors_on(:month) }
      end

      context 'with valid data' do
        it { is_expected.not_to have(1).errors_on(:month) }
      end
    end

    context 'monthly_payment_present' do
      let(:valid_customer) { FactoryGirl.create(:customer, monthly_payment: true) }
      let(:invalid_customer) { FactoryGirl.create(:customer) }

      context 'with invalid data' do
        subject { described_class.create(customer_id: invalid_customer.id, month: Date.today) }

        it { is_expected.to have(1).errors_on(:monthly_payment) }
      end

      context 'with valid data' do
        subject { described_class.create(customer_id: valid_customer.id, month: Date.today) }

        it { is_expected.not_to have(1).errors_on(:monthly_payment) }
      end
    end

    context 'client_info_present' do
      let(:customer) { FactoryGirl.create(:customer) }

      context 'with invalid data' do
        subject { described_class.create(customer_id: customer.id, month: Date.today) }

        it { is_expected.to have(9).errors_on(:client_info) }
      end

      context 'with valid data' do
        let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
        subject { described_class.create(customer_id: customer.id, month: Date.today) }

        it { is_expected.not_to have(9).errors_on(:client_info) }
      end
    end

    context 'hours_present' do
      let(:customer) { FactoryGirl.create(:customer) }

      context 'with invalid data' do
        subject { described_class.create(customer_id: customer.id, month: Date.today) }

        it { is_expected.to have(1).errors_on(:hours) }
      end

      context 'with valid data' do
        let(:vendor) { FactoryGirl.create(:vendor) }
        let(:hour) { FactoryGirl.create(:hour, vendor_id: vendor.id, customer_id: customer.id) }
        subject { described_class.create(customer_id: customer.id, month: hour.month) }

        it { is_expected.not_to have(1).errors_on(:hours) }
      end
    end
  end
end
