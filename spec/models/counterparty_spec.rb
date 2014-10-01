require 'rails_helper'

RSpec.describe Counterparty, :type => :model do
  subject { build(:counterparty) }

  it { should be_valid }
end
