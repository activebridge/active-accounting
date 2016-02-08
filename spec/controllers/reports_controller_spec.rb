require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#index' do
    let(:article) { FactoryGirl.create(:revenue_article) }
    let(:counterparty) { FactoryGirl.create(:counterparty) }
    let!(:register) do
      FactoryGirl.create(:register,
                         article: article,
                         counterparty: counterparty,
                         value: 10,
                         date: '10/10/2014')
    end

    let(:article2) { FactoryGirl.create(:revenue_article) }
    let(:counterparty2) { FactoryGirl.create(:counterparty) }
    let!(:register2) do
      FactoryGirl.create(:register,
                         article: article2,
                         counterparty: counterparty2,
                         value: 25,
                         date: '12/11/2014')
    end

    let!(:register3) do
      FactoryGirl.create(:register,
                         article: article2,
                         counterparty: counterparty2,
                         value: 20,
                         date: '12/10/2014')
    end

    let!(:register_plan) do
      FactoryGirl.create(:register_plan,
                         article: article2,
                         counterparty: counterparty2,
                         value: 50,
                         date: '13/10/2014')
    end

    context 'returns registers for selected months' do
      before do
        get :index, report_type: 'revenues', months: ['10/2014', '11/2014'], rate_currency: 10
      end

      it do
        expect(json).to eq(
          ['articles' =>
            [
              {
                'article' => article.name,
                'values' => { '10' => '10.0', '11' => '0' },
                'valuesPlan' => { '10' => '0', '11' => '0' },
                'counterparties' => [
                  'counterparty' => counterparty.name,
                  'values' => { '10' => '10.0', '11' => '0' },
                  'valuesPlan' => { '10' => '0', '11' => '0' }
                ],
                'article_type' => 'Revenue',
                'article_id' => article.id
              },
              {
                'article' => article2.name,
                'values' => { '10' => '20.0', '11' => '25.0' },
                'valuesPlan' => { '10' => '50.0', '11' => '0' },
                'counterparties' => [
                  'counterparty' => counterparty2.name,
                  'values' => { '10' => '20.0', '11' => '25.0' },
                  'valuesPlan' => { '10' => '50.0', '11' => '0' }
                ],
                'article_type' => 'Revenue',
                'article_id' => article2.id
              }
            ],
           'total_values' => { '10' => 30.0, '11' => 25.0 },
           'total_values_plan' => { '10' => 50.0 }
          ]
        )
      end
    end
  end

  describe '#years' do
    let!(:register) { FactoryGirl.create(:register) }

    subject { get :years }

    it { is_expected.to be_success }
  end
end
