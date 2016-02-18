require 'rails_helper'

RSpec.describe Vacation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:vendor) }
  end
end
