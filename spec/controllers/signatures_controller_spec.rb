require 'rails_helper'

RSpec.describe SignaturesController, type: :controller do
  let(:signature_params) { { signature: signature_attributes } }
  let(:signature) { create(:signature) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    before do
      signature
      get :index
    end

    it { expect(json.first.keys).to include('assigned') }
    it { expect(json.first.keys).to include('short_name_ua') }
  end

  describe '#create' do
    context 'valid params' do
      let(:signature_attributes) { attributes_for(:signature) }
      subject { -> { post :create, signature_params } }
      it { is_expected.to change(Signature, :count).by(1) }
    end

    context 'invalid params' do
      let(:signature_attributes) { attributes_for(:signature, name_en: 'Smith') }
      subject { -> { post :create, signature_params } }
      it { is_expected.to_not change(Signature, :count) }
    end
  end

  describe '#update' do
    let(:params) { { id: signature.id }.merge(signature_params) }

    context 'valid params' do
      let(:signature_attributes) { attributes_for(:signature) }
      before { put :update, params }
      it { expect(json['name_en']).to eq signature_attributes[:name_en] }
    end

    context 'invalid params' do
      let(:signature_attributes) { attributes_for(:signature, name_en: 'Smith') }
      before { put :update, params }
      it { expect(json['error']).to be }
    end
  end

  describe '#destroy' do
    let!(:signature) { create(:signature) }
    subject { -> { delete :destroy, id: signature.id } }

    context 'success' do
      it { is_expected.to change(Signature, :count).by(-1) }
    end

    context 'assigned' do
      before { create(:vendor_act, signature_id: signature.id) }
      it { is_expected.to change(Signature, :count).by(0) }
    end
  end
end
