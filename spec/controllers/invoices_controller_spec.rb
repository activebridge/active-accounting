require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#show' do
    before { get :show, id: customer.id, month: '01/2015' }

    it { is_expected.to render_template('show.pdf.slim') }
  end
end
