require 'rails_helper'

RSpec.describe RegistersController, :type => :controller do

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end


  describe "#index" do
    let(:article_type_revenue) { FactoryGirl.create(:article, type: Article::TYPES::REVENUE) }
    let!(:register_article_cost) { FactoryGirl.create(:register, value: 200) }
    let!(:register_date_not_yesterday) { FactoryGirl.create(:register, date: Date.yesterday-1.day, value: 150) }
    let!(:register_article_revenue) { FactoryGirl.create(:register, article_id: article_type_revenue.id ) }

    context 'returns registers with article type "cost"' do
      before do
        get :index, article_id: "costs"
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
end
