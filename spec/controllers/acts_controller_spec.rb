require 'rails_helper'

RSpec.describe ActsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer, value_payment: 15) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#show' do
    before { get :show, id: customer.id, month: Time.current.strftime('%m/%Y') }

    it { is_expected.to render_template('show_customer.pdf.erb') }
  end
end
