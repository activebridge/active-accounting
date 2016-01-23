require 'rails_helper'

RSpec.describe VendorAct, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:vendor) }
  end

  context 'validates' do
    it { is_expected.to validate_uniqueness_of(:month).with_message('Act for this month has been already created!') }
  end
end
