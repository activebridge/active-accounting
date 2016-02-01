require 'rails_helper'

RSpec.describe ClientInvoice, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:customer) }
  end

  context 'validates' do
    it { is_expected.to validate_uniqueness_of(:month).with_message('Invoice for this month has been already created!') }
  end
end
