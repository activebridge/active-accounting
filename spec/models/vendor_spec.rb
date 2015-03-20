require 'rails_helper'

RSpec.describe Vendor, :type => :model do
  it { should belong_to(:customer) }
end
