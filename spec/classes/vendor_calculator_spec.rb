require 'rails_helper'

RSpec.describe VendorCalculator, type: :class do
  let(:vendor) { FactoryGirl.create(:vendor, value_payment: 2000) }
  let(:params) { {rateDollar: 22, month: '6/2015', translation: 0} }
  let(:vendor_calculator) { VendorCalculator.new(vendor, params) }

  it "total_money" do
    expect(vendor_calculator.total_money).to eq('46620.65')
  end

  it "total_money_words" do
    expect(vendor_calculator.total_money_words('46620.65')).to eq('Сорок шiсть тисяч шiстсот двадцять гривень')
  end

  it "params_new_act" do
    expect(vendor_calculator.params_new_act).to eq({ vendor_id: vendor.id , total_money: "46620.65", month: '6/2015'.to_date })
  end

  it "cashing_tax" do
    expect(vendor_calculator.cashing_tax).to eq(333.169875)
  end
end
