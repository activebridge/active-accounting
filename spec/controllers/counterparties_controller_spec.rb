require 'rails_helper'

RSpec.describe CounterpartiesController, :type => :controller do

  describe "#index" do
    let!(:activeCounterparty) { FactoryGirl.create(:counterparty) }
    let!(:inactiveCounterparty) { FactoryGirl.create(:counterparty, active: false) }

    it 'unload only active counterparties' do
      get :index, scope: 'active', format: :json
      JSON.parse(response.body).each do |json|
        json["active"].should == true
      end
    end

    it 'unload only inactive counterparties' do
      get :index, scope: 'inactive', format: :json
      JSON.parse(response.body).each do |json|
        json["active"].should == false
      end
    end
  end

end
