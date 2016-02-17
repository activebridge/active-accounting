require 'rails_helper'

RSpec.describe CounterpartiesController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:vendor_attributes) { FactoryGirl.attributes_for(:vendor, name: 'Name', type: 'Vendor') }
  let(:invalid_vendor_attributes) { FactoryGirl.attributes_for(:vendor, name: '', type: '') }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    let!(:active_counterparty) { FactoryGirl.create(:counterparty) }
    let!(:inactive_counterparty) { FactoryGirl.create(:counterparty, active: false) }

    context 'returns active сounterparties' do
      before do
        get :index, scope: 'active', format: :json
      end
      it { expect(json).to have(1).items }
      it { expect(json.first['active']).to be_truthy }
      it { expect(json[0]).to have_key('customer') }
    end

    context 'returns inactive сounterparties' do
      before do
        get :index, scope: 'inactive', format: :json
      end

      it { expect(json).to have(1).items }
      it { expect(json.first['active']).to be_falsey }
    end

    context 'returns list of versions' do
      before do
        get :index, scope: 'inactive', format: :json
        inactive_counterparty.update(value_payment: 400)
      end

      it { expect(json.first['versions']).to have(1).item }
    end
  end

  describe '#create' do
    subject { -> { post :create, counterparty: counterparty_params } }

    context 'with valid params' do
      let(:counterparty_params) { vendor_attributes }
      it { is_expected.to change(Counterparty, :count).by(1) }
      it { expect(response).to be_success }
    end

    context 'with invalid params' do
      let(:counterparty_params) { invalid_vendor_attributes }
      it { is_expected.to_not change(Counterparty, :count) }
    end
  end

  describe '#update' do
    context 'with valid params' do
      before { put :update, id: vendor.id, counterparty: vendor_attributes }

      it { expect(json['name']).to eq(vendor_attributes[:name]) }
      it { expect(json['type']).to eq(vendor_attributes[:type]) }
    end

    context 'with invalid params' do
      before { put :update, id: vendor.id, counterparty: invalid_vendor_attributes }

      it { expect(json['status']).to eq('error') }
    end
  end

  describe '#destroy' do
    let!(:assigned_counterparty) { FactoryGirl.create(:counterparty) }
    let!(:register) { FactoryGirl.create(:register, counterparty_id: assigned_counterparty.id) }
    let!(:counterparty) { FactoryGirl.create(:counterparty, active: false) }

    context 'successful removal counterparty' do
      it { expect { delete :destroy, id: counterparty.id }.to change(Counterparty, :count).by(-1) }
    end

    context 'deletion of counterparty unsuccessful' do
      it { expect { delete :destroy, id: assigned_counterparty.id }.to change(Counterparty, :count).by(0) }
    end
  end

  describe '#payments' do
    let!(:counterparty_with_payment_fact) do
      FactoryGirl.create(:counterparty,
                         monthly_payment: true,
                         value_payment: 1000)
    end
    let!(:register1) { FactoryGirl.create(:register, counterparty: counterparty_with_payment_fact, date: Date.today) }

    let!(:counterparty) { FactoryGirl.create(:counterparty) }
    let!(:register2) { FactoryGirl.create(:register, counterparty: counterparty, date: Date.today) }

    let!(:counterparty_without_pay) do
      FactoryGirl.create(:counterparty,
                         monthly_payment: true,
                         value_payment: 2000)
    end

    context 'list without pay сounterparties with monthly payment (registers fact)' do
      before do
        get :payments, month: Date.today
      end

      it { expect(json).to have(1).items }
      it do
        expect(json).to eq(
          [{ 'name' => counterparty_without_pay.name,
             'id' => counterparty_without_pay.id,
             'value_payment' => 2000.0,
             'type' => counterparty_without_pay.type }
          ]
        )
      end
    end

    context 'list without pay сounterparties with monthly payment (registers plan)' do
      before do
        get :payments, month: Date.today, sandbox: true
      end

      it { expect(json).to have(2).items }
      it do
        expect(json).to eq(
          [{ 'name' => counterparty_with_payment_fact.name,
             'id' => counterparty_with_payment_fact.id,
             'value_payment' => 1000.0,
             'type' => counterparty_without_pay.type },
           { 'name' => counterparty_without_pay.name,
             'id' => counterparty_without_pay.id,
             'value_payment' => 2000.0,
             'type' => counterparty_without_pay.type }
          ]
        )
      end
    end
  end
end
