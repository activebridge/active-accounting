require 'rails_helper'

RSpec.describe VendorInfo, type: :model do
  let(:vendor_info) { FactoryGirl.create(:vendor_info, name: 'Галушка Олександр Анатолійович') }

  context 'associations' do
    it { is_expected.to belong_to(:vendor) }
  end

  it 'convert short_name' do
    expect(vendor_info.short_name).to eq('Галушка О.А.')
  end
end
