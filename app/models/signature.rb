class Signature < ActiveRecord::Base

  validates :name_ua, :name_en, :title_ua, :title_en, presence: true

  has_many :client_acts
  has_many :vendor_acts
  has_many :client_invoices
  has_many :vendor_orders

  scope :last_used, -> (table) {
    joins("LEFT OUTER JOIN #{table} records ON records.signature_id = signatures.id")
    .order("MAX(records.created_at) DESC, MAX(signatures.created_at) DESC")
    .group('signatures.id').uniq.first
  }
end
