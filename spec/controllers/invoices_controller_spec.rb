require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }

  before do
    controller.stub(:authenticate_user!) { true }
  end

  describe '#show' do
    before { get :show, { id: customer.id, month: '01/2015' } }

    it { should render_template('show.pdf.slim') }
  end
end
