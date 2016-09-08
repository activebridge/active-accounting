class Customer < Counterparty
  has_one  :client_info, dependent: :destroy
  has_many :client_acts, dependent: :destroy
  has_many :client_invoices, dependent: :destroy
  has_many :hours

  after_create :create_info_record

  delegate :repr_name, :name, :address, :invoice_id, :agreement_number, :title_en, :title_ua, :agreement_date, to: :client_info, prefix: true

  def create_info_record
    create_client_info
  end
end
