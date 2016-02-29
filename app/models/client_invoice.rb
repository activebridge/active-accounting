class ClientInvoice < ActiveRecord::Base
  include ClientMethods
  include ValidationOnMonth

  validate :month_uniqueness, on: :create
  validate :monthly_payment_present, if: :customer
  validate :client_info_present
  validate :hours_present
  belongs_to :customer

  def months
    customer.client_invoices.map(&:month)
  end
end
