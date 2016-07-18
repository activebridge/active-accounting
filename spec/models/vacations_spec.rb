require 'rails_helper'

RSpec.describe Vacation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:vendor) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:start) }
    it { is_expected.to validate_presence_of(:ending) }
    it { is_expected.to validate_presence_of(:vendor_id) }
    it { is_expected.to validate_uniqueness_of(:start).scoped_to(:vendor_id) }
    it { is_expected.to validate_uniqueness_of(:ending).scoped_to(:vendor_id) }
  end
end
