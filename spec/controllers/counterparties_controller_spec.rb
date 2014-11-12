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
end
