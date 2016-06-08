require 'rails_helper'

RSpec.describe VacationsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:vacation) { FactoryGirl.create(:vacation, vendor_id: vendor.id) }
  let(:vacation_attributes) { FactoryGirl.attributes_for(:vacation) }
  let(:invalid_vacation_attributes) { FactoryGirl.attributes_for(:vacation, start: true, ending: '') }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
    session[:counterparty_id] = vendor.id
  end

  describe '#index' do
    subject { get :index, vendor_id: vendor.id }
    it { is_expected.to be_success }
  end

  describe '#create' do
    subject { -> { post :create, vacation: vacation_params } }

    context 'with valid params' do
      let(:vacation_params) { vacation_attributes }
      it { is_expected.to change(Vacation, :count).by(1) }
    end

    context 'with invalid params' do
      let(:vacation_params) { invalid_vacation_attributes }
      it { is_expected.to_not change(Vacation, :count) }
    end
  end

  describe '#destroy' do
    subject { delete :destroy, id: vacation.id }
    it { is_expected.to be_success }
  end
end
