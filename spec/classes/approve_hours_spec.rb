require 'rails_helper'

RSpec.describe ApproveHours, type: :class do
  let(:customer) { FactoryGirl.create(:customer) }
  let!(:vendor) { FactoryGirl.create(:vendor, approve_hours: true, customer_id: customer.id) }
  let(:approve_hours) { ApproveHours.new }

  it "send an email for vendors" do
    expect { approve_hours.working }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  context 'confirm' do
    let(:verifier) { approve_hours.send(:verifier) }
    let(:hour_params) { approve_hours.send(:hour_params, vendor) }
    let(:token) { verifier.generate(hour_params) }

    it 'add hours' do
      expect { approve_hours.confirm(token) }.to change(Hour, :count).by(1)
    end

    it 'not add hours if invalid token' do
      expect { approve_hours.confirm(verifier.generate(vendor)) }.to_not change(Hour, :count)
    end

    it 'not add hours if hours for current month has exist' do
      Hour.create(hour_params)

      expect { approve_hours.confirm(token) }.to_not change(Hour, :count)
    end
  end
end
