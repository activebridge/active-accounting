require 'rails_helper'

RSpec.describe PlanRegistersController, type: :controller do
  let(:article) { create(:article) }
  let(:counterparty) { create(:counterparty) }
  let(:vendor) { create(:counterparty) }
  let(:plan_register) { create(:register_plan) }
  let(:plan_register_attributes) { attributes_for(:register_plan, article_id: article.id, date: '18-01-2016', counterparty_id: counterparty.id, vendor_id: vendor.id) }
  let(:invalid_plan_register_attributes) { attributes_for(:register_plan, date: '', value: '', type: '') }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#create' do
    subject { -> { post :create, plan_register: plan_register_params } }

    context 'with valid params' do
      let(:plan_register_params) { plan_register_attributes }
      it { is_expected.to change(Register, :count).by(1) }
    end

    context 'with invalid params' do
      let(:plan_register_params) { invalid_plan_register_attributes }
      it { is_expected.to_not change(Register, :count) }
    end
  end
end
