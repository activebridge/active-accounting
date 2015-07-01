require 'rails_helper'

RSpec.describe VendorAct, type: :model do

  context "associations" do
    it { should belong_to(:vendor) }
  end

end
