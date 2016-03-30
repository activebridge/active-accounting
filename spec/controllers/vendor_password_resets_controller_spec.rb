require 'rails_helper'

RSpec.describe VendorPasswordResetsController, type: :controller do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let(:vendor_attributes) { FactoryGirl.attributes_for(:vendor, current_password: vendor.password, new_password: '11111111') }
  let(:invalid_vendor_attributes) { FactoryGirl.attributes_for(:vendor, current_password: '', new_password: '') }

  before { session[:counterparty_id] = vendor.id }

  describe '#create' do
    context 'create password resets' do
      before { post :create, email: vendor.email }

      it { expect(Vendor.last.password_reset_token).to be }
      it { expect(response).to redirect_to(vendor_login_url) }
      it { expect(flash[:notice]).to eq('Email sent with password reset instructions.') }
    end
  end

  describe '#edit' do
    before do
      vendor.send_password_reset
      get :edit, id: vendor.password_reset_token
    end

    it { expect(response).to be_success }
  end

  describe '#update' do
    context 'with valid params' do
      before do
        vendor.send_password_reset
        put :update, id: vendor.password_reset_token, vendor: { password: vendor.password }
      end

      # context 'password reset sent at < 2 hours ago' do
      # it { expect(response).to redirect_to(new_password_reset_path) }
      # it { expect(flash[:alert]).to eq("Password reset has expired.") }
      # end

      context 'password reset sent at > 2 hours ago' do
        it { expect(response).to redirect_to(vendor_login_url) }
        it { expect(flash[:notice]).to eq('Password has been reset!') }
      end
    end

    # context 'with invalid params' do
    # before { put :update, id: '', vendor: { password: '' } }

    # it { expect(response).to render_template(:edit) }
    # end
  end

  describe '#change_password' do
    before do
      post :change_password, vendor_params
      vendor.reload
    end

    context 'with valid params' do
      let(:vendor_params) { vendor_attributes }
      it { expect(vendor.password).to eq(vendor_attributes[:new_password]) }
      it { expect(json['status']).to eq('ok') }
    end

    context 'with valid params' do
      let(:vendor_params) { invalid_vendor_attributes }
      it { expect(json['status']).to eq('error') }
    end
  end
end
