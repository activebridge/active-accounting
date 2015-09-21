require 'rails_helper'

RSpec.describe Holiday, type: :model do
  context "validation rules" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.not_to allow_value('').for(:name) }
    it { is_expected.not_to allow_value('').for(:date) }
  end
end
