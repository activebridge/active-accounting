require 'rails_helper'

RSpec.describe Signature, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:client_acts) }
    it { is_expected.to have_many(:vendor_acts) }
    it { is_expected.to have_many(:client_invoices) }
    it { is_expected.to have_many(:vendor_orders) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:name_ua) }
    it { is_expected.to validate_presence_of(:name_en) }
    it { is_expected.to validate_presence_of(:title_ua) }
    it { is_expected.to validate_presence_of(:title_en) }
    it { is_expected.to allow_value('Jackson Smith').for(:name_ua) }
    it { is_expected.not_to allow_value('Smith').for(:name_ua) }
    it { is_expected.to allow_value('Jackson Smith').for(:name_en) }
    it { is_expected.not_to allow_value('Smith').for(:name_en) }
  end

  describe 'scope' do
    let(:yesterday) { Time.zone.now - 1.days }
    let(:beginning_of_day) { Time.zone.now.beginning_of_day }
    let(:first_signature) { create(:signature, created_at: yesterday) }
    let(:second_signature) { create(:signature, created_at: beginning_of_day) }
    let(:third_signature) { create(:signature) }

    before do
      first_signature.vendor_orders << create(:vendor_order)
      third_signature.vendor_orders << create(:vendor_order, created_at: yesterday)

      first_signature.vendor_acts << create(:vendor_act, created_at: yesterday)
      second_signature.vendor_acts << create(:vendor_act)

      second_signature.client_acts << create(:client_act)
    end

    context '.last_used' do
      context 'for client_acts' do
        subject { described_class.last_used('client_acts') }
        it { is_expected.to eq second_signature }
      end

      context 'for vendor_orders' do
        subject { described_class.last_used('vendor_orders') }
        it { is_expected.to eq first_signature }
      end

      context 'for client_invoices' do
        subject { described_class.last_used('client_invoices') }
        it { is_expected.to eq third_signature }
      end

      context 'for vendor_acts' do
        subject { described_class.last_used('vendor_acts') }
        it { is_expected.to eq second_signature }
      end
    end
  end

  describe '.simple_name_en' do
    subject { create(:signature, name_en: name).simple_name_en }

    context 'When name is long' do
      let(:name) { 'Jackson Carter Smith' }

      it { is_expected.to eq 'Jackson Smith' }
    end

    context 'When name is short' do
      let(:name) { 'Jackson Smith' }

      it { is_expected.to eq 'Jackson Smith' }
    end
  end

  describe '.short_name_ua' do
    subject { create(:signature, name_ua: name).short_name_ua }

    context 'When name is long' do
      let(:name) { 'Jackson Carter Smith' }

      it { is_expected.to eq 'Jackson C.S.' }
    end

    context 'When name is short' do
      let(:name) { 'Jackson Smith' }

      it { is_expected.to eq 'Jackson S.' }
    end
  end
end
