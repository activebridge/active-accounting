require 'rails_helper'

RSpec.describe VendorCalculator, type: :class do
  let(:params) { { rateDollar: 22, month: '6/2015', translation: 0 } }
  let(:vendor_calculator) { VendorCalculator.new(vendor, params) }

  before(:all) { FactoryGirl.create(:tax) }

  context 'vendor with currency of USD' do
    let(:vendor) { FactoryGirl.create(:vendor, value_payment: 2000) }

    it 'total_money' do
      expect(vendor_calculator.total_money).to eq('44993.38')
    end

    it 'total_money_words' do
      expect(vendor_calculator.total_money_words('44993.38')).to eq('Сорок чотири тисячi дев’ятсот дев’яносто три гривні')
    end

    it 'params_new_act' do
      expect(vendor_calculator.params_new_act).to eq(vendor_id: vendor.id, total_money: '44993.38', month: '6/2015'.to_date)
    end
  end

  context 'vendor with currency of UAH' do
    let(:vendor) { FactoryGirl.create(:vendor, value_payment: 7000, currency_monthly_payment: 'UAH') }

    it 'total_money' do
      expect(vendor_calculator.total_money).to eq('7242.13')
    end

    it 'total_money_words' do
      expect(vendor_calculator.total_money_words('7745.19')).to eq('Сiм тисяч сiмсот сорок п’ять гривень')
    end

    it 'params_new_act' do
      expect(vendor_calculator.params_new_act).to eq(vendor_id: vendor.id, total_money: '7242.13', month: '6/2015'.to_date)
    end
  end
end
