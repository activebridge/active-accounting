require 'rails_helper'

RSpec.describe OrderFeaturesController, type: :controller do
  let(:primary_feature) { FactoryGirl.create(:primary) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:vendor_order) { FactoryGirl.create(:vendor_order, vendor_id: vendor.id) }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe '#index' do
    let!(:additional_feature) { FactoryGirl.create(:additional) }

    context 'returns primary features' do
      before do
        get :index, type: 'Additional'
      end
      it { expect(json).to have(1).items }
      it { expect(json.first['type']).to eq('Additional') }
    end

    context 'returns additional features' do
      before do
        get :index, type: 'additional'
      end

      it { expect(json).to have(1).items }
      it { expect(json.first['type']).to eq('Additional') }
    end

    context 'returns inactive сounterparties' do
      before do
        get :index
      end

      it { expect(json).to have(1).items }
    end
  end

  describe '#destroy' do
    context 'successful removal of feature' do
      it { expect { delete :destroy, id: primary_feature.id }.to change(Feature, :count).by(0) }
    end

    context 'removal of feature in order' do
      let(:order_feature) { FactoryGirl.create(:order_feature) }
      let(:primary_feature) { order_feature.feature }
      let(:vendor_order) { order_feature.vendor_order }

      it { expect { delete :destroy, id: primary_feature.id, vendor_order_id: vendor_order.id }.to change(Feature, :count).by(1) }
      it { expect { delete :destroy, id: primary_feature.id, vendor_order_id: vendor_order.id }.to change(OrderFeature, :count).by(0) }
    end
  end

  describe '#create' do
    let(:attributes_for_feature) { FactoryGirl.attributes_for(:primary) }

    context 'successfully adding of feature' do
      it { expect { post :create, feature: attributes_for_feature }.to change(Feature, :count).by(1) }
    end

    context 'successfully adding of feature and add feature in order' do
      it { expect { post :create, feature: attributes_for_feature, vendor_order_id: vendor_order.id }.to change(Feature, :count).by(1) }
      it { expect { post :create, feature: attributes_for_feature, vendor_order_id: vendor_order.id }.to change(OrderFeature, :count).by(1) }
    end
  end

  describe '#show' do
    it { expect { get :show, id: primary_feature.id, vendor_order_id: vendor_order.id }.to change(OrderFeature, :count).by(1) }
  end

  describe '#update' do
    let(:attributes_for_feature) { FactoryGirl.attributes_for(:primary) }

    before do
      put :update, id: primary_feature.id, feature: attributes_for_feature
    end

    it { expect(json['name']).to eq(attributes_for_feature[:name]) }
  end
end
