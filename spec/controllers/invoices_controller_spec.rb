require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:customer) { FactoryGirl.create(:customer, value_payment: 15) }
  let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
  let(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }
  let(:client_invoice) { FactoryGirl.create(:client_invoice, customer_id: customer.id) }
  let(:fail_customer) { FactoryGirl.create(:customer, value_payment: 1000) }
  let(:fail_hour) { FactoryGirl.create(:hour, customer_id: fail_customer.id, vendor_id: vendor.id) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    subject { get :index, customer_id: customer.id }
    it { is_expected.to be_success }
  end

  describe '#create' do
    context 'valid params' do
      subject { -> { post :create, params } }
      let(:params) do
        {
          customer_id: customer.id,
          month: hour.month,
          invoice: {
            customer_id: customer.id,
            month: hour.month
          }
        }
      end
      it { is_expected.to change(ClientInvoice, :count).by(1) }
    end

    context 'invalid params' do
      context 'without hours' do
        before { post :create, customer_id: fail_customer.id, month: Time.current.strftime('%m/%Y') }
        it { expect(response.status).to eq(422) }
        it { expect(json['messages']).to eq(%w(no_hours)) }
      end

      context 'without info' do
        before { post :create, customer_id: fail_customer.id, month: fail_hour.month }
        it { expect(response.status).to eq(422) }
        it { expect(json['messages']).to eq(%w(you_must_fill_fields name agreement_number invoice_id address repr_name title_en title_ua agreement_date)) }
      end
    end
  end

  describe '#show' do
    subject { -> { get :show, id: client_invoice.id, month: Time.current.strftime('%m/%Y') } }
    it { expect(subject.call).to render_template('show.pdf.slim') }
  end
end
