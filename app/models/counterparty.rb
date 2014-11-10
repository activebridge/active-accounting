class Counterparty < ActiveRecord::Base
  validates :name, presence: true

  scope :by_status, -> (status) {
    where("active = ?", status)
  }

end
