require 'rails_helper'

RSpec.describe ClientInfosController, type: :controller do
  let(:client_info_attributes) { FactoryGirl.attributes_for(:client_info) }
  let!(:client_info) { FactoryGirl.create(:client_info) }

  before do
    allow(controller).to receive(:authenticate_admin!) { true }
  end

  describe '#update' do
    before do
      put :update, id: client_info.id, client_info: client_info_attributes, format: :json
      client_info.reload
    end

    it { expect(client_info.name).to eql(client_info_attributes[:name]) }
    it { expect(client_info.agreement_number).to eql(client_info_attributes[:agreement_number]) }
    it { expect(client_info.invoice_id).to eql(client_info_attributes[:invoice_id].to_i) }
    it { expect(client_info.address).to eql(client_info_attributes[:address]) }
    it { expect(client_info.repr_name).to eql(client_info_attributes[:repr_name]) }
    it { expect(client_info.agreement_date).to eql(client_info_attributes[:agreement_date]) }
  end
end
