require 'rails_helper'

RSpec.describe MissingHoursController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "#index" do
    context 'hours are present' do
      let!(:vendor) { create(:vendor) }
      let(:customer) { create(:customer) }
      let(:date) { Date.today.at_beginning_of_month }
      let!(:hour) { create(:hour, vendor: vendor, customer: customer, month: date) }

      before { get :index }

      it { expect(json).to be_empty }
    end

    context 'hours are blank' do
      let!(:vendor) { create(:vendor) }

      before { get :index }

      it { expect(json).to have(1).items }
    end
  end
end
