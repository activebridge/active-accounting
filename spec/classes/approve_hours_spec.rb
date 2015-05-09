require 'rails_helper'

RSpec.describe ApproveHours, type: :class do
  let(:customer) { FactoryGirl.create(:customer) }
  let!(:vendor) { FactoryGirl.create(:vendor, approve_hours: true, customer_id: customer.id) }
  let(:approve_hours) { ApproveHours.new(Date.new(2015,6,30)) }

  it "add hours for vendors" do
    expect { approve_hours.working }.to change(Hour, :count).by(1)
  end

  it "send an email for vendors and admin" do
    expect { approve_hours.working }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end
end
