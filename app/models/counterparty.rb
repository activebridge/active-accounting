class Counterparty < ActiveRecord::Base
  validates :name, presence: true

  scope :by_active, -> (active) {
    if active
      where(active: (active=='true'))
    else
      all
    end
  }
end
