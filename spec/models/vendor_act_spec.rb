require 'rails_helper'

RSpec.describe VendorAct, type: :model do

  context "associations" do
    it { should belong_to(:vendor) }
  end

  context 'validates' do
    it { should validate_uniqueness_of(:month).with_message('Act for this month has been created already!') }
  end
end
