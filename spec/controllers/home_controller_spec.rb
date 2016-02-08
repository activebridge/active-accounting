require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "#index" do
    subject { get :index }

    context 'with current admin' do
      before { sign_in :admin, admin }
      it { is_expected.to be_success }
    end
  end
end
