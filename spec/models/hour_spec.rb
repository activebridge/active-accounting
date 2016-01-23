require 'rails_helper'

RSpec.describe Hour, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:vendor) }
  end

  context 'validation rules' do
    it { is_expected.to validate_presence_of(:hours) }
    it { is_expected.not_to allow_value('').for(:hours) }
  end
end
