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

  def successful_payment?(date, type)
    type = type ? Register::TYPES::PLAN : Register::TYPES::FACT
    registers.by_month(date).where(type: type).any?
  end

  alias_method :assigned, :assigned?
end
