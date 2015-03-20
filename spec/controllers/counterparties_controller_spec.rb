require 'rails_helper'

RSpec.describe CounterpartiesController, :type => :controller do

  describe "#index" do
    let!(:active_counterparty) { FactoryGirl.create(:counterparty) }
    let!(:inactive_counterparty) { FactoryGirl.create(:counterparty, active: false) }

    context 'returns active сounterparties' do
      before do
        get :index, scope: 'active', format: :json
      end
      it { expect(json).to have(1).items }
      it { expect(json.first["active"]).to be_truthy }
      it { expect(json[0]).to have_key('customer') }
    end

    context 'returns inactive сounterparties' do
      before do
        get :index, scope: 'inactive', format: :json
      end

      it { expect(json).to have(1).items }
      it { expect(json.first["active"]).to be_falsey }
    end
  end

  describe "#destroy" do
    let!(:assigned_counterparty) { FactoryGirl.create(:counterparty) }
    let!(:register) { FactoryGirl.create(:register, counterparty_id: assigned_counterparty.id) }
    let!(:counterparty) { FactoryGirl.create(:counterparty, active: false) }

    context 'successful removal counterparty' do
      it { expect{ delete :destroy, id: counterparty.id }.to change(Counterparty, :count).by(-1) }
    end

    context 'deletion of counterparty unsuccessful' do
      it { expect{ delete :destroy, id: assigned_counterparty.id }.to change(Counterparty, :count).by(0) }
    end
  end

  describe "#payments" do
    let!(:counterparty_with_payment_fact) { FactoryGirl.create(:counterparty,
                                                          monthly_payment:true,
                                                          value_payment:1000) }
    let!(:register1) { FactoryGirl.create(:register, counterparty: counterparty_with_payment_fact) }

    let!(:counterparty) { FactoryGirl.create(:counterparty) }
    let!(:register2) { FactoryGirl.create(:register, counterparty: counterparty) }

    let!(:counterparty_without_pay) { FactoryGirl.create(:counterparty,
                                                          monthly_payment:true,
                                                          value_payment:2000) }

    context 'list without pay сounterparties with monthly payment (registers fact)' do
      before do
        get :payments, month: Date.today
      end

      it { expect(json).to have(1).items }
      it { expect(json).to eq(
            [ { "name" => counterparty_without_pay.name,
                "id" => counterparty_without_pay.id,
                "value_payment" => 2000.0 }
            ]
          )
        }
    end

    context 'list without pay сounterparties with monthly payment (registers plan)' do
      before do
        get :payments, month: Date.today, sandbox: true
      end

      it { expect(json).to have(2).items }
      it { expect(json).to eq(
            [ { "name" => counterparty_with_payment_fact.name,
                "id" => counterparty_with_payment_fact.id,
                "value_payment" => 1000.0 },
              { "name" => counterparty_without_pay.name,
                "id" => counterparty_without_pay.id,
                "value_payment" => 2000.0 }
            ]
          )
        }
    end
  end
end
