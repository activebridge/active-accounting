require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  let!(:register) { FactoryGirl.create(:register) }
  let(:register_attributes) { FactoryGirl.attributes_for(:register, date: Date.yesterday, value: '100', type: 'Fact') }
  let(:invalid_register_attributes) { FactoryGirl.attributes_for(:register, date: '', value: '', type: '') }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe '#index' do
    subject { get :index, register: register_attributes }
    it 'returns a successful 200 response' do
      is_expected.to be_success
    end
  end

  describe '#years' do
    subject { get :years }
    it 'returns a successful 200 response' do
      is_expected.to be_success
    end
  end
end
