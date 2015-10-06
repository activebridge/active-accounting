require 'rails_helper'

RSpec.describe HoursController, type: :controller do

  let(:customer) { FactoryGirl.create(:customer) }
  let(:vendor) { FactoryGirl.create(:vendor, customer_id: customer.id, approve_hours: true) }
  let!(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }
  let(:hour_attributes) { FactoryGirl.attributes_for(:hour, customer_id: customer.id, vendor_id: vendor.id, hours: 30) }
  let(:unvalid_hour_attributes) { FactoryGirl.attributes_for(:hour, hours:'', customer_id:'', month: '')}

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "#index" do
    it 'returns a successful 200 response' do
      get :index, month: hour.month, customer_id: customer.id
      expect(response).to be_success
    end
  end

  describe '#create' do
    before(:each) do |test|
      session[:vendor_id] = vendor.id
    end

    it 'add hour' do
      expect {
        post :create, { hour: hour_attributes }
      }.to change(Hour, :count).by(1)
    end

    it 'add hour from unvalid hour attributes' do
      expect {
        post :create, { hour: unvalid_hour_attributes }
      }.to_not change(Hour, :count)
    end
  end

  describe "#update" do
    before do
      put :update, { id: hour.id, hour: hour_attributes}
      hour.reload
    end

    it { expect(hour.hours).to eql(hour_attributes[:hours]) }
  end

  describe "#destroy" do
    it { expect { delete :destroy, id: hour.id }.to change(Hour, :count).by(-1) }
  end

  describe "#total_hours" do
    before { get :total_hours, { year: hour.month.year } }

    it { expect(json).to have(1).items }
    it { expect(json.first['report_month']).to eql(hour.month.month) }
  end

   describe "#years" do
    before { get :years }

    it { expect(json['years']).to have(1).items }
    it { expect(json['years'].first).to eql(hour.month.year) }
  end

  describe "#approve_hours" do

    it 'The successful addition of records' do
      post :approve_hours
      expect(json['status']).to eql('ok')
    end
  end

  describe "#confirm" do
    before { post :approve_hours }

    it 'add hours' do
      vendor.reload
      expect { get :confirm, { token: vendor.auth_token } }.to change(Hour, :count).by(1)
    end

    it 'not add hours when dublicate request' do
      get :confirm, { token: SecureRandom.urlsafe_base64 }

      expect(response).to be_not_found
    end
  end
end
