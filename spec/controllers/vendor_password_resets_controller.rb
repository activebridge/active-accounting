require 'rails_helper'

RSpec.describe VendorPasswordResetsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:vendor_attributes) { FactoryGirl.attributes_for(:vendor, current_password: vendor.password, new_password: '11111111') }

  before(:each) do |test|
    session[:vendor_id] = vendor.id
  end

  describe '#create' do

    it 'create password_resets' do
      post :create, email: vendor.email
      expect(Vendor.last.password_reset_token).to be
    end
  end

  describe '#change_password' do
    before do
      post :change_password, vendor_attributes
      vendor.reload
    end

    it 'change password' do
      expect(vendor.password).to eql(vendor_attributes[:new_password])
    end
  end
end
