require 'rails_helper'

RSpec.describe VendorCalculator, type: :class do
  let(:params) { {rateDollar: 22, month: '6/2015', translation: 0} }
  let(:vendor_calculator) { VendorCalculator.new(vendor, params) }

  context 'vendor with currency of USD' do
    let(:vendor) { FactoryGirl.create(:vendor, value_payment: 2000) }

    it "total_money" do
      expect(vendor_calculator.total_money).to eq('46984.67')
    end

    it "total_money_words" do
      expect(vendor_calculator.total_money_words('46984.67')).to eq('Сорок шiсть тисяч дев’ятсот вiсiмдесят чотири гривні')
    end

    it "params_new_act" do
      expect(vendor_calculator.params_new_act).to eq({ vendor_id: vendor.id , total_money: "46984.67", month: '6/2015'.to_date })
    end
  end

  context 'vendor with currency of UAH' do
    let(:vendor) { FactoryGirl.create(:vendor, value_payment: 7000, currency_monthly_payment: "UAH") }

    it "total_money" do
      expect(vendor_calculator.total_money).to eq('7745.19')
    end

    it "total_money_words" do
      expect(vendor_calculator.total_money_words('7745.19')).to eq('Сiм тисяч сiмсот сорок п’ять гривень')
    end

    it "params_new_act" do
      expect(vendor_calculator.params_new_act).to eq({ vendor_id: vendor.id , total_money: "7745.19", month: '6/2015'.to_date })
    end
  end
end
