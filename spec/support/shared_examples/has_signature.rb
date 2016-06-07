RSpec.shared_examples "has signature" do

  subject { create(described_class.table_name.singularize, :for_signature) }

  describe "associations" do
    it { is_expected.to belong_to(:signature) }
  end

  describe 'validates' do
    it { is_expected.to validate_presence_of(:signature_id) }
  end

  describe 'set signature' do
    let(:subject_signature) { subject.signature }

    it { expect(subject.signature).to be }
  end
end
