module HasSignature
  extend ActiveSupport::Concern

  included do
    belongs_to :signature

    validates :signature_id, presence: true

    before_validation :set_signature, on: :create

  end

  private

  def set_signature
    self.signature = Signature.last_used(self.class.table_name)
  end
end
