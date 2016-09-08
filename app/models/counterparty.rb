class Counterparty < ActiveRecord::Base
  has_many :payment_histories, dependent: :destroy
  has_many :registers, dependent: :destroy
  has_many :vendors, through: :registers

  module TYPES
    CUSTOMER = 'Customer'
    VENDOR = 'Vendor'
    OTHER = 'Other'
    HR = 'HR'

    DISPLAY_TYPES = constants.collect { |type| const_get(type) }
  end

  TYPES::DISPLAY_TYPES.each do |type|
    define_method("#{type.downcase}?") do
      self.type == type
    end
  end

  validates :name, :type, presence: true

  scope :by_active, -> (scope) { send(scope) if scope }

  scope :by_group, -> (group) { where(type: group) if group }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :monthly_payment, -> { where(monthly_payment: true) }

  scope :paid_for, lambda { |date|
    joins(:registers).where('extract(month from date) = ? AND extract(year from date) = ?', date.month, date.year)
  }

  scope :unpaid_for, lambda { |date, type|
    paid_ids = monthly_payment.for_registers(type).paid_for(date).select('id').uniq
    monthly_payment.where('id not in (?)', paid_ids).active
  }

  scope :for_registers, -> (type) { joins(:registers).where(registers: { type: type }) }

  def assigned?
    registers.any?
  end

  def successful_payment?
    registers.by_month(DateTime.now.to_s).where(type: Register::TYPES::FACT).any?
  end

  def check_changes(admin_id)
    return unless previous_changes.include?('value_payment')
    payment_histories.create(
      admin_id: admin_id,
      value_payment: value_payment
    )
  end

  alias assigned assigned?
  alias successful_payment successful_payment?
end
