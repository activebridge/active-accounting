require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do
	let(:article_type_revenue) { FactoryGirl.create(:article, type: Article::TYPES::REVENUE) }
  let!(:active_counterparty) { FactoryGirl.create(:counterparty) }
  let!(:active_counterparty1) { FactoryGirl.create(:counterparty) }
  let!(:active_counterparty2) { FactoryGirl.create(:counterparty) }
  let!(:register_article_revenue) { FactoryGirl.create(:register, date: 1.month.ago, article_id: article_type_revenue.id, counterparty_id: active_counterparty.id ) }
  let!(:register_article_revenue1) { FactoryGirl.create(:register, date: 2.month.ago, article_id: article_type_revenue.id, counterparty_id: active_counterparty.id ) }
  let!(:register_article_revenue2) { FactoryGirl.create(:register, date: 2.month.ago, article_id: article_type_revenue.id, counterparty_id: active_counterparty2.id ) }

	describe "#index" do
		context 'returns reports with month 9 and type "revenue"' do
      before do
        get :index, report_type: "revenues", month: ['9/2014']
      end
      it { expect(json).to have(1).items }
    end

    context 'returns json reports' do
    	before do
        month = 1.month.ago
        year = Date.new.year
        get :index, report_type: "revenues", month: ["#{month}/#{year}", "#{month-1}/#{year}"]
      end

      it{ expect(json[0]).to have(5).items }
    end
  end
end