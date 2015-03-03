class Counterparty < ActiveRecord::Base

  has_many :registers

  module TYPES
    CUSTOMER = 'Customer'
    VENDOR = 'Vendor'
    OTHER = 'Other'
  end

  def customer?
    type == TYPES::CUSTOMER
  end

  def vendor?
    type == TYPES::VENDOR
  end

  def other?
    type == TYPES::OTHER
  end

  validates :name, :type, presence: true

  scope :by_active, -> (scope) {
    self.send(scope) if scope
  }

  scope :by_group, -> (group) { where(type: group) if group}
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :monthly_payment, -> { where(monthly_payment: true) }

  scope :paid_for, -> (date) {
     joins(:registers).where("extract(month from date) = ? AND extract(year from date) = ?", date.month, date.year)
  }

  scope :unpaid_for, -> (date, type) {
    paid_ids = monthly_payment.for_registers(type).paid_for(date).select('id').uniq
    monthly_payment.where("id not in (?)", paid_ids)
  }

  scope :for_registers, -> (type) {
    joins(:registers).where(registers: {type: type})
  }

  def assigned?
    registers.any?
  end

  def successful_payment?
    registers.by_month(DateTime.now.to_s).where(type: Register::TYPES::FACT).any?
  end

  alias_method :assigned, :assigned?
  alias_method :successful_payment, :successful_payment?
end
