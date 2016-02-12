require 'rails_helper'

RSpec.describe VacationsController, type: :controller do

  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:vacation) { FactoryGirl.create(:vacation, vendor_id: vendor.id) }
  let(:vacation_attributes) { FactoryGirl.attributes_for(:vacation) }
  let(:unvalid_vacation_attributes) { FactoryGirl.attributes_for(:vacation, start:'', ending:'') }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
    session[:counterparty_id] = vendor.id
  end

  describe "#index" do
    subject { get :index, vendor_id: vendor.id }
    it 'returns a successful 200 response' do
      expect(subject).to be_success
    end
  end

  describe '#create' do
    before(:each) do |test|
      session[:counterparty_id] = vendor.id
    end

    it 'add vacation' do
      expect {
        post :create, { vacation: vacation_attributes }
      }.to change(Vacation, :count).by(1)
    end

    it 'add vacation from unvalid vacation attributes' do
      expect {
        post :create, { vacation: unvalid_vacation_attributes }
      }.to_not change(Vacation, :count)
    end
  end
  
  describe "#destroy" do
    it { expect { delete :destroy, id: vacation.id }.to change(Vacation, :count).by(-1) }
  end
end
