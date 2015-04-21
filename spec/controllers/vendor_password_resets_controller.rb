require 'rails_helper'

RSpec.describe VendorPasswordResetsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:counterparty, type: 'Vendor') }

  describe '#create' do
    let!(:vendor_attributes) { FactoryGirl.attributes_for(:counterparty) }

    it 'create password_resets' do
      post :create, email: vendor.email
      expect(Vendor.last.password_reset_token).to be
    end
  end
end
