require 'rails_helper'

RSpec.describe OrderFeature, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:vendor_order) }
    it { is_expected.to belong_to(:feature) }
  end
end
