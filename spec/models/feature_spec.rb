require 'rails_helper'

RSpec.describe Feature, type: :model do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:vendor_orders) }
  end

  context 'validation rules' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.not_to allow_value('').for(:name) }
  end
end
