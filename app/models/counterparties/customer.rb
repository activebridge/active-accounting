class Customer < Counterparty
  after_create :create_info_record

  has_many :vendors
  has_many :hours
  has_one  :client_info, dependent: :destroy

  delegate :repr_name, :name, :address, :invoice_id, :agreement, to: :client_info, prefix: true

  def create_info_record
    self.create_client_info
  end
end
