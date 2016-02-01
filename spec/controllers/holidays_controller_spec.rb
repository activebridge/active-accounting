require 'rails_helper'

RSpec.describe HolidaysController, type: :controller do
  let!(:holiday) { FactoryGirl.create(:holiday) }
  let(:holiday_attributes) { FactoryGirl.attributes_for(:holiday, name: 'name', date: '20.01.2016') }
  let(:invalid_holiday_attributes) { FactoryGirl.attributes_for(:holiday, name: '', date: '') }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe '#index' do
    it 'returns a successful 200 response' do
      get :index, years: holiday.date
      expect(response).to be_success
    end
  end

  describe '#create' do
    subject { -> { post :create, holiday: holiday_params } }

    context 'with valid params' do
      let(:holiday_params) { holiday_attributes }
      it { is_expected.to change(Holiday, :count).by(1) }
    end

    context 'with invalid params' do
      let(:holiday_params) { invalid_holiday_attributes }
      it { is_expected.to_not change(Holiday, :count) }
    end
  end

  describe '#update' do
    subject { -> { put :update, id: holiday.id, holiday: holiday_params } }
    before { subject.call }

    context 'with valid params' do
      let(:holiday_params) { holiday_attributes }
      it { expect(json['name']).to eq(holiday_attributes[:name]) }
      it { expect(json['date']).to eq(holiday_attributes[:date]) }
    end

    context 'with invalid params' do
      let(:holiday_params) { invalid_holiday_attributes }
      it { expect(json['status']).to eq('error') }
    end
  end

  describe '#destroy' do
    it { expect { delete :destroy, id: holiday.id }.to change(Holiday, :count).by(-1) }
  end
end
