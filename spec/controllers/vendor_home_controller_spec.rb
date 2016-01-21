require 'rails_helper'

RSpec.describe VendorHomeController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }

  describe "#index" do
    subject { get :index }

    context 'with vendor id' do
      before { session[:counterparty_id] = vendor.id }
      it { is_expected.to be_success }
    end

    context 'without vendor id' do
      it { is_expected.to redirect_to(vendor_login_path) }
    end
  end
end

