require 'rails_helper'

RSpec.describe Counterparty, :type => :model do
  subject { build(:counterparty) }

  it { is_expected.to be_valid }
end
