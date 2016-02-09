class ClientInvoice < ActiveRecord::Base
  include ClientMethods

  validates :month, uniqueness: { message: I18n.t('activerecord.errors.models.client_invoice.attributes.month.uniqueness') }
  validate :monthly_payment_present
  validate :client_info_present
  validate :hours_present
  belongs_to :customer
end
