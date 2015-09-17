require 'rails_helper'

RSpec.describe Article, type: :model do

  context "association" do
    it { is_expected.to have_many(:registers) }
  end

  context 'boolean methods' do
    before do
      @revenue = FactoryGirl.create(:article, type: Article::TYPES::REVENUE)
      @cost = FactoryGirl.create(:article, type: Article::TYPES::COST)
      @translation = FactoryGirl.create(:article, type: Article::TYPES::TRANSLATION)
      @loan = FactoryGirl.create(:article, type: Article::TYPES::LOAN)
    end

    context "#revenue?" do
      it { expect(@revenue.revenue?).to be true }
      it { expect(@cost.revenue?).to be false }
    end

    context "#cost?" do
      it { expect(@cost.cost?).to be true }
      it { expect(@revenue.cost?).to be false }
    end

    context "#translation?" do
      it { expect(@translation.translation?).to be true }
      it { expect(@revenue.translation?).to be false }
    end

    context "#loan?" do
      it { expect(@loan.loan?).to be true }
      it { expect(@revenue.loan?).to be false }
    end
  end
end
