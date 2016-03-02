require 'rails_helper'

RSpec.describe RegistersController, type: :controller do
  let(:article) { FactoryGirl.create(:article) }
  let(:register) { FactoryGirl.create(:register) }
  let(:register_attributes) { FactoryGirl.attributes_for(:register, date: '18-01-2016', type: 'Fact', value: 100, article_id: article.id) }
  let(:invalid_register_attributes) { FactoryGirl.attributes_for(:register, date: '', type: '', value: '', article_id: '') }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    let(:article_type_revenue) { FactoryGirl.create(:article, type: Article::TYPES::REVENUE) }
    let!(:register_article_cost) { FactoryGirl.create(:register, value: 200) }
    let!(:register_date_not_yesterday) { FactoryGirl.create(:register, date: Date.yesterday - 1.day, value: 150) }
    let!(:register_article_revenue) { FactoryGirl.create(:register, article_id: article_type_revenue.id) }

    context 'returns registers with article type "cost"' do
      before do
        get :index, article_id: 'costs'
      end

      it { expect(json).to have(2).items }
    end

    context 'returns registers with article type "revenue"' do
      before do
        get :index, article_id: 'revenues'
      end

      it { expect(json).to have(1).items }
    end

    context 'returns registers with article type "revenue" and date yesterday' do
      before do
        get :index, article_id: 'costs', date: Date.yesterday
      end

      it { expect(json).to have(1).items }
    end

    context 'returns registers with value > 101' do
      before do
        get :index, value: 101
      end

      it { expect(json).to have(2).items }
    end
  end

  describe '#show' do
    context 'returns register in json' do
      before { get :show, id: register.id }

      it { expect(JSON.parse(response.body)['id']).to eq(register.id) }
    end
  end

  describe '#create' do
    subject { -> { post :create, register: register_params } }

    context 'with valid params' do
      let(:register_params) { register_attributes }
      it { is_expected.to change(Register, :count).by(1) }
      it { expect(response).to be_success }
    end

    context 'with invalid params' do
      let(:register_params) { invalid_register_attributes }
      it { is_expected.to_not change(Register, :count) }
    end
  end

  describe '#update' do
    context 'with valid params' do
      before { put :update, id: register.id, register: register_attributes }

      it { expect(json['date']).to eq(register_attributes[:date]) }
      it { expect(json['value']).to eq(register_attributes[:value]) }
    end

    context 'with invalid params' do
      before { put :update, id: register.id, register: invalid_register_attributes }

      it { expect(json['status']).to eq('error') }
    end
  end

  describe '#destroy' do
    it { expect { delete :destroy, id: register.id }.to change(Register, :count).by(0) }
  end
end
