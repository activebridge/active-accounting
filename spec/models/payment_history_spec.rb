require 'rails_helper'

RSpec.describe PaymentHistory, type: :model do
  let(:payment_history) { FactoryGirl.create(:payment_history) }

  context 'associations' do
    it { is_expected.to belong_to(:counterparty) }
  end
end
