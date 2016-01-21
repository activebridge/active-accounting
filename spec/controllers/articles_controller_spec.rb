require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  let(:article) { FactoryGirl.create(:article) }
  let(:register) { FactoryGirl.create(:register) }
  let(:article_attributes) { FactoryGirl.attributes_for(:article, name: 'Name', type: 'Cost') }
  let(:invalid_article_attributes) { FactoryGirl.attributes_for(:article, name: '', type: '') }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "#index" do
    subject { get :index, article: article_attributes }

    context 'returns a successful 200 response' do
      it { is_expected.to be_success }
    end
  end

  describe '#create' do
    subject { -> { post :create, article: article_params } }

    context 'with valid params' do
      let(:article_params) { article_attributes }
      it { is_expected.to change(Article, :count).by(1) }
    end

    context 'with invalid params' do
      let(:article_params) { invalid_article_attributes }
      it { is_expected.to_not change(Article, :count) }
    end
  end

  describe "#update" do
    context 'with valid params' do
      before { put :update, { id: article.id, article: article_attributes } }

      it { expect(json['name']).to eq(article_attributes[:name]) }
      it { expect(json['type']).to eq(article_attributes[:type]) }
    end

    context 'with invalid params' do
      before { put :update, { id: article.id, article: invalid_article_attributes } }

      it { expect(json['status']).to eq('error') }
    end
  end

  describe "#destroy" do
    it 'with registers' do
      article.registers << register
      expect { delete :destroy, id: article.id }.to_not change(Article, :count)
    end

    it 'without registers' do
      expect { delete :destroy, id: article.id }.to change(Article, :count).by(0)
    end
  end
end
