require 'rails_helper'

RSpec.describe Holiday, type: :model do
  context "validation rules" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date) }
    it { should_not allow_value('').for(:name) }
    it { should_not allow_value('').for(:date) }
  end
end
