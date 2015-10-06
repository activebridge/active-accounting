require 'rails_helper'

RSpec.describe ApproveHours, type: :class do
  let(:customer) { FactoryGirl.create(:customer) }
  let!(:vendor) { FactoryGirl.create(:vendor, approve_hours: true, customer_id: customer.id) }
  let(:approve_hours) { ApproveHours.new }

  it "add hours for vendors" do
    expect { approve_hours.confirm(vendor) }.to change(Hour, :count).by(1)
  end

  it "send an email for vendors" do
    expect { approve_hours.working }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
