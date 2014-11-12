require 'rails_helper'

RSpec.describe CounterpartiesController, :type => :controller do

  describe "#index" do
    let!(:active_counterparty) { FactoryGirl.create(:counterparty) }
    let!(:inactive_counterparty) { FactoryGirl.create(:counterparty, active: false) }

    context 'returns active ' do
      before do
        get :index, scope: 'active', format: :json
      end

      it { expect(json).to have(1).items }
      it { expect(json.first["active"]).to be_truthy }
    end

    context 'inactive' do
      before do
        get :index, scope: 'inactive', format: :json
      end

      it { expect(json).to have(1).items }
      it { expect(json.first["active"]).to be_falsey }
    end
  end
end
