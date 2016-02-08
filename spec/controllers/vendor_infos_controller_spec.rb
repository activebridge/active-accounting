require 'rails_helper'

RSpec.describe VendorInfosController, type: :controller do
  let(:vendor_info_attributes) { FactoryGirl.attributes_for(:vendor_info) }
  let!(:vendor_info) { FactoryGirl.create(:vendor_info) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#update' do
    before do
      put :update, id: vendor_info.id, vendor_info: vendor_info_attributes, format: :json
      vendor_info.reload
    end

    it { expect(vendor_info.name).to eql(vendor_info_attributes[:name]) }
    it { expect(vendor_info.ipn).to eql(vendor_info_attributes[:ipn]) }
    it { expect(vendor_info.contract).to eql(vendor_info_attributes[:contract]) }
    it { expect(vendor_info.address).to eql(vendor_info_attributes[:address]) }
    it { expect(vendor_info.account).to eql(vendor_info_attributes[:account]) }
    it { expect(vendor_info.bank).to eql(vendor_info_attributes[:bank]) }
    it { expect(vendor_info.mfo).to eql(vendor_info_attributes[:mfo].to_i) }
  end
end
