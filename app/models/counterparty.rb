class Counterparty < ActiveRecord::Base

  has_many :registers

  validates :name, presence: true

  scope :by_active, -> (scope) {
    self.send(scope) if scope
  }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :active_payment, -> { where(monthly_payment: true) }

  scope :unpaid_for, -> (date, type) {
    select{|c| !c.successful_payment?(date, type)}
  }

   scope :successful, -> (date, type) {
    joins(:register).where(register: {type: type}).by_month(date)
  }

  def assigned?
    registers.any?
  end

  def successful_payment?(date, type=Register::TYPES::FACT)
    registers.by_month(date).by_type_register(type).any?
  end

  alias_method :assigned, :assigned?
end
