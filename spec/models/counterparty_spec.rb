require 'rails_helper'

RSpec.describe Counterparty, type: :model do
  subject { build(:counterparty) }

  context 'associations' do
    it { is_expected.to have_many(:payment_histories).dependent(:destroy) }
    it { is_expected.to have_many(:registers).dependent(:destroy) }
    it { is_expected.to have_many(:vendors).through(:registers) }
  end
end
