require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#create' do
    subject { -> { post :create, id: vendor.id } }
    it { is_expected.to change(ActionMailer::Base.deliveries, :count).by(1) }
    it { expect(response).to be_success }
  end
end
