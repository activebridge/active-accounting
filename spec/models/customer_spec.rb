require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:vendors) }

  context "after create callbacks" do
    let(:customer) { create(:customer) }

    it { expect(customer).to callback(:create_info_record).after(:create) }
  end
end
