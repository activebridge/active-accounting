require 'rails_helper'

RSpec.describe VendorOrdersController, type: :controller do
  let(:vendor) { create(:vendor, :with_info) }
  let(:vendor_order) { create(:vendor_order, vendor_id: vendor.id) }
  let(:vendor_not_info) { create(:vendor) }

  before do
    create(:signature)
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    subject { get :index, vendor_id: vendor.id }

    it { is_expected.to be_success }
  end

  describe '#create' do
    let(:month) { Time.current.strftime('%m/%Y') }
    let(:attributes_for_order) { attributes_for(:vendor_order, month: month, vendor_id: vendor.id) }

    it 'add act' do
      expect { post :create, vendor_order: attributes_for_order, vendor_id: vendor.id }.to change(VendorOrder, :count).by(1)
    end

    context "responds with a 422 status, vendor hasn't info" do
      let(:attributes_for_order) { { month: month, vendor_id: vendor_not_info.id } }

      before { post :create, vendor_order: attributes_for_order, vendor_id: vendor.id }

      it { expect(response.status).to eq(422) }
      it { expect(json['messages']).to eq('you_must_fill_fields' => %w(name ipn address contract account bank mfo agreement_date)) }
    end
  end

  describe '#show' do
    before { get :show, id: vendor_order.id, format: 'pdf' }

    it { is_expected.to render_template('order_vendor.pdf.erb') }
  end

  describe '#update' do
    let(:signature) { create(:signature) }

    let(:params) { attributes_for(:vendor_order, signature_id: signature.id) }
    before { put :update, id: vendor_order.id, vendor_order: params }
    it { expect(json['signature']['id']).to eq signature.id }
  end
end
