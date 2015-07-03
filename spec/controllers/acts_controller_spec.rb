require 'rails_helper'

RSpec.describe ActsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer, value_payment: 15) }
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:hour) { FactoryGirl.create(:hour, customer_id: customer.id, vendor_id: vendor.id ) }

  before do
    controller.stub(:authenticate_user!) { true }
  end

  describe '#show' do
    before { get :show, { id: customer.id, month: Time.current.strftime('%m/%Y') } }

    it { should render_template('show_customer.pdf.erb') }
  end
end

