require 'rails_helper'

RSpec.describe InvoiceCalculator, type: :class do
  let(:customer) { FactoryGirl.create(:customer, value_payment: 10) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id, hours: 160 ) }
  let(:invoice_calculator) { InvoiceCalculator.new(customer, hour.month) }

  it "invoice_number" do
    expect(invoice_calculator.invoice_number).to eq(1)
  end

  it "total_money" do
    expect(invoice_calculator.total_money).to eq(1600)
  end

  it "hours_by_month" do
    expect(invoice_calculator.hours_by_month).not_to be_empty
  end
end
