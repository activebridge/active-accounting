require 'rails_helper'

RSpec.describe VendorSessionsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }

  describe '#create' do
    let(:format) { :js }
    subject { -> { xhr :post, :create, vendor_params, format: format } }

    context 'with valid params' do
      let(:vendor_params) { { email: vendor.email, password: vendor.password } }
      it { is_expected.to change { vendor.reload.signed_in } }
    end

    context 'with invalid params' do
      let(:vendor_params) { { email: '', password: '' } }
      before { subject.call }
      it { expect(flash[:error]).to eq 'Invalid email or password' }
    end
  end

  describe '#destroy' do
    before { delete :destroy }

    it { expect(vendor.signed_in).to eq(false) }
    it { is_expected.to redirect_to(vendor_login_path) }
  end
end
