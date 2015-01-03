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
    if type
      type = Register::TYPES::PLAN
    else
      type = Register::TYPES::FACT
    end
    registers.by_month(date).where(type: type).any?
  end

  alias_method :assigned, :assigned?
end
