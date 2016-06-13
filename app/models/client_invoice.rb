class ClientInvoice < ActiveRecord::Base
  include ClientMethods
  include ValidationOnMonth
  include HasSignature

  validate :month_uniqueness, on: :create, if: :customer
  validate :monthly_payment_present
  validate :client_info_present
  validate :hours_present
  belongs_to :customer

  def months
    customer.client_invoices.map(&:month)
  end
end
