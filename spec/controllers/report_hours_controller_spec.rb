require 'rails_helper'

RSpec.describe ReportHoursController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:vendor) { FactoryGirl.create(:vendor, customer_id: customer.id) }

  describe '#create' do
    it 'valid params' do
      expect do
        post :create, report_hour: { customer_id: customer.id, vendor_id: vendor.id, hours: 160, month: Date.current.beginning_of_month }
      end.to change(Hour, :count).by(1)
    end

    it 'invalid params' do
      expect do
        post :create, report_hour: { customer_id: customer.id, vendor_id: vendor.id, hours: '', month: Date.current.beginning_of_month }
      end.to_not change(Hour, :count)
    end
  end
end
