require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:customer) { FactoryGirl.create(:customer, monthly_payment: true, value_payment: 15) }
  let(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }
  let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
  let(:client_invoice) { FactoryGirl.create(:client_invoice, customer_id: customer.id, month: hour.month) }
  let(:fail_customer) { FactoryGirl.create(:customer, value_payment: 1000) }
  let(:fail_hour) { FactoryGirl.create(:hour, customer_id: fail_customer.id, vendor_id: vendor.id) }
  let(:params) { FactoryGirl.attributes_for(:client_invoice, customer_id: customer.id, month: hour.month, invoice: invoice ) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    subject { get :index, customer_id: customer.id }
    it { is_expected.to be_success }
  end

  describe '#create' do
    context 'valid params' do
      let(:invoice) { FactoryGirl.attributes_for(:client_invoice, customer_id: customer.id, month: hour.month ) }
      subject { -> { post :create, params } }
      it { is_expected.to change(ClientInvoice, :count).by(1) }
    end

    context 'invalid params' do
      let(:invoice) { FactoryGirl.attributes_for(:client_invoice, customer_id: fail_customer.id, month: fail_hour.month ) }
      subject { -> { post :create, params } }
      it { is_expected.to_not change(ClientInvoice, :count) }
    end
  end

  describe '#show' do
    subject { -> { get :show, id: client_invoice.id, month: hour.month } }
    it { expect(subject.call).to render_template('show.pdf.slim') }
  end

  describe '#destroy' do
    subject { delete :destroy, id: client_invoice.id }
    it { is_expected.to be_success}
  end
end
