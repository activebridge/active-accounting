require 'rails_helper'

RSpec.describe ActsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:customer) { FactoryGirl.create(:customer, monthly_payment: true, value_payment: 15) }
  let(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }
  let!(:client_info) { customer.client_info.update(FactoryGirl.attributes_for(:client_info)) }
  let(:client_act) { FactoryGirl.create(:client_act, customer_id: customer.id, month: hour.month) }
  let(:fail_customer) { FactoryGirl.create(:customer, value_payment: 1000) }
  let(:fail_hour) { FactoryGirl.create(:hour, customer_id: fail_customer.id, vendor_id: vendor.id) }
  let(:params) { FactoryGirl.attributes_for(:client_act, customer_id: customer.id, month: hour.month, act: act ) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    subject { get :index, customer_id: customer.id }
    it { is_expected.to be_success }
  end

  describe '#create' do
    context 'valid params' do
      let(:act) { FactoryGirl.attributes_for(:client_act, customer_id: customer.id, month: hour.month ) }
      subject { -> { post :create, params } }
      it { expect(subject.call).to render_template('show_customer.pdf.erb') }
      it { is_expected.to change(ClientAct, :count).by(1) }
    end

    context 'invalid params' do
      let(:act) { FactoryGirl.attributes_for(:client_act, customer_id: fail_customer.id, month: fail_hour.month ) }
      subject { -> { post :create, params } }
      it { is_expected.to_not change(ClientAct, :count) }
    end
  end

  describe '#show' do
    subject { -> { get :show, id: client_act.id, month: client_act.month } }
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

  describe '#destroy' do
    subject { delete :destroy, id: client_act.id }
    it { is_expected.to be_success}
  end
end
