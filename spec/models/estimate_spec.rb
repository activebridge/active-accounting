require 'rails_helper'

RSpec.describe Estimate, type: :model do
  context "associations" do
    it { should belong_to(:customer) }
    it { should belong_to(:vendor) }
  end

  context "validation rules" do
    it { should validate_presence_of(:hours) }
    it { should_not allow_value('').for(:hours) }
  end
end
