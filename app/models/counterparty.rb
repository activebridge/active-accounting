class Counterparty < ActiveRecord::Base

  has_many :registers

  validates :name, presence: true

  scope :by_active, -> (scope) {
    self.send(scope) if scope
  }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def assigned?
    registers.any?
  end

  def successful_payment?
    registers.by_month(DateTime.now).where(type: Register::TYPES::FACT).any?
  end

  alias_method :assigned, :assigned?
  alias_method :successful_payment, :successful_payment?
end
