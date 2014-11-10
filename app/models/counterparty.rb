class Counterparty < ActiveRecord::Base
  validates :name, presence: true

  scope :by_active, -> (scope) {
    self.send(scope) if scope
  }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
