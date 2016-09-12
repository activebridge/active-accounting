require 'rails_helper'

RSpec.describe Register, type: :model do
  context 'scopes' do
    context '.by_months' do
      let(:date1) { '10/12/2014' }
      let(:date2) { '05/10/2014' }

      before do
        FactoryGirl.create(:register, date: date1)
        FactoryGirl.create(:register, date: date2)
      end

      context 'returns records' do
        subject { Register.by_months([Date.parse(date1), Date.parse(date2)]) }

        it { is_expected.to have(2).items }
      end

      context 'exepts nil' do
        subject { Register.by_months(nil) }

        it { is_expected.to be_blank }
      end
    end

    context '.by_counterparty' do
      let(:counterparty) { create(:counterparty) }
      let(:data) { counterparty }
      let!(:register_one) { create(:register, counterparty: counterparty) }
      let!(:register_two) { create(:register) }

      subject { Register.by_counterparty(data) }

      it { is_expected.to have(1).item }
    end

    context '.by_counterparty' do
      let(:vendor) { create(:vendor) }
      let(:data) { vendor }
      let!(:register_one) { create(:register, vendor: vendor) }
      let!(:register_two) { create(:register) }

      subject { Register.by_vendor(data) }

      it { is_expected.to have(1).item }
    end
  end
end
