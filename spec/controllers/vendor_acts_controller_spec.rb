require 'rails_helper'

RSpec.describe VendorActsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor, monthly_payment: true, value_payment: 1000) }
  let!(:vendor_info) { vendor.vendor_info.update(FactoryGirl.attributes_for(:vendor_info)) }
  let(:vendor_act) { FactoryGirl.create(:vendor_act, vendor_id: vendor.id) }

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

    context 'render html' do
      before { post :create, vendor_id: vendor.id, month: month, rateDollar: 22 }

      it { is_expected.to render_template('show_vendor.pdf.erb') }
    end

    context "responds with a 422 status, vendor hasn't monthly payment" do
      let(:vendor_not_monthly_payment) { FactoryGirl.create(:vendor) }

      before { post :create, vendor_id: vendor_not_monthly_payment.id, month: month, rateDollar: 22 }

      it { expect(response.status).to eq(422) }
      it { expect(json['messages']).to eq('vendor_value_payment' => ['no_monthly_payment']) }
    end

    context "responds with a 422 status, vendor hasn't info" do
      let(:vendor_not_info) { FactoryGirl.create(:vendor, monthly_payment: true, value_payment: 1000) }

      before { post :create, vendor_id: vendor_not_info.id, month: month, rateDollar: 22 }

      it { expect(response.status).to eq(422) }
      it { expect(json['messages']).to eq('you_must_fill_fields' => %w(name ipn address contract account bank mfo agreement_date)) }
    end

    it 'add act' do
      expect { post :create, vendor_id: vendor.id, month: month, rateDollar: 22 }.to change(VendorAct, :count).by(1)
    end
  end

  describe '#show' do
    before { get :show, id: vendor_act.id }

    it { is_expected.to render_template('show_vendor.pdf.erb') }
  end

  describe '#update' do
    let(:signature) { create(:signature) }
    let(:attr) { { total_money: 200, signature_id: signature.id } }

    before { put :update, id: vendor_act.id, vendor_act: attr }

    it { expect(vendor_act.reload.total_money).to eq('200') }
    it { expect(vendor_act.signature).not_to eq signature }
    it { expect(vendor_act.reload.signature).to eq signature }
  end
end
