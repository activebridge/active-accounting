require 'rails_helper'

RSpec.describe PlanRegistersController, type: :controller do
  let(:article) { FactoryGirl.create(:article) }
  let(:plan_register) { FactoryGirl.create(:register_plan) }
  let(:plan_register_attributes) { FactoryGirl.attributes_for(:register_plan, date: Date.yesterday, value: '100', type: 'Plan', article_id: article.id) }
  let(:invalid_plan_register_attributes) { FactoryGirl.attributes_for(:register_plan, date: '', value: '', type: '') }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
  end

  describe "#create" do
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
