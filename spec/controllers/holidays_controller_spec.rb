require 'rails_helper'

RSpec.describe HolidaysController, type: :controller do
  let!(:holiday) { FactoryGirl.create(:holiday) }
  let(:holiday_attributes) { FactoryGirl.attributes_for(:holiday) }
  let(:unvalid_holiday_attributes) { FactoryGirl.attributes_for(:holiday, name:'', date:'')}

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "#index" do
    it 'returns a successful 200 response' do
      get :index, years: holiday.date
      expect(response).to be_success
    end
  end

  describe '#create' do
    it 'add holiday' do
      expect {
        post :create, { holiday: holiday_attributes }
      }.to change(Holiday, :count).by(1)
    end

    it 'add holiday from unvalid holiday attributes' do
      expect {
        post :create, { holiday: unvalid_holiday_attributes }
      }.to_not change(Holiday, :count)
    end
  end

  describe "#destroy" do
    it { expect { delete :destroy, id: holiday.id }.to change(Holiday, :count).by(-1) }
  end
end
