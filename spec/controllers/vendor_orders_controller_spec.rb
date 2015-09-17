require 'rails_helper'

RSpec.describe VendorOrdersController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:vendor_info) { vendor.vendor_info.update(FactoryGirl.attributes_for(:vendor_info)) }
  let!(:vendor_order) { FactoryGirl.create(:vendor_order, vendor_id: vendor.id) }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe '#index' do
    before { get :index, vendor_id: vendor.id }

    it { expect(json).to have(1).items }
    it { expect(json.first['id']).to eq(vendor_order.id) }
  end

  describe '#create' do
    let(:month) { Time.current.strftime('%m/%Y') }
    let(:attributes_for_order) { FactoryGirl.attributes_for(:vendor_order, month: month, vendor_id: vendor.id) }

    it 'add act' do
      expect { post :create, vendor_order: attributes_for_order, vendor_id: vendor.id }.to change(VendorOrder, :count).by(1)
    end

    context "responds with a 422 status, vendor hasn't info" do
      let(:vendor_not_info) { FactoryGirl.create(:vendor) }

      before { post :create, { vendor_id: vendor_not_info.id, month: month} }

      it { expect(response.status).to eq(422) }
      it { expect(json['messages']).to eq(["you_must_fill_fields", "name", "ipn", "address", "contract", "account", "bank", "mfo", "agreement_date"]) }
    end

  end

  describe '#show' do
    before { get :show, id: vendor_order.id, format: 'pdf' }

    it { is_expected.to render_template('order_vendor.pdf.erb') }
  end
end
