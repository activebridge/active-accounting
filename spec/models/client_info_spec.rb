require 'rails_helper'

RSpec.describe ClientInfo, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:customer) }
  end
end
