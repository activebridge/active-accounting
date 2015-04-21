require 'rails_helper'

RSpec.describe Info, type: :model do
  context "associations" do
    it { should belong_to(:customer) }
  end
end
