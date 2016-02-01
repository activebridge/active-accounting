require 'rails_helper'

RSpec.describe ActsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer, value_payment: 15) }
  let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
  let(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }
  let(:client_act) { FactoryGirl.create(:client_act, customer_id: customer.id) }
  let(:fail_customer) { FactoryGirl.create(:customer, value_payment: 1000) }
  let(:fail_hour) { FactoryGirl.create(:hour, customer_id: fail_customer.id, vendor_id: vendor.id) }
  let(:vendor) { FactoryGirl.create(:vendor) }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
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
          act: {
            customer_id: customer.id,
            month: hour.month
          }
        }
      end
      it { expect(subject.call).to render_template('show_customer.pdf.erb') }
      it { is_expected.to change(ClientAct, :count).by(1) }
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
    subject { -> { get :show, id: client_act.id, month: Time.current.strftime('%m/%Y') } }
    it { expect(subject.call).to render_template('show_customer.pdf.erb') }
  end

  describe '#update' do
    context 'valid params' do
      subject { put :update, id: client_act.id, total_money: '1200' }
      it { is_expected.to be_success }
    end

    context 'invalid params' do
      subject { put :update, id: client_act.id, total_money: nil }
      it { expect(subject.status).to eq(422) }
    end
  end
end
