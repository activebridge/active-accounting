require 'rails_helper'

RSpec.describe ClientInfo, type: :model do
  context "associations" do
    it { should belong_to(:customer) }
  end
end