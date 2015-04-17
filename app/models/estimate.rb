class Estimate < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, :month, :customer_id, presence: true

  delegate :name, to: :customer, prefix: true
  delegate :name, to: :vendor, prefix: true

  scope :by_month, -> (date) {
    date = date.to_date
    where("extract(month from month) = ? AND extract(year from month) = ?", date.month, date.year)
  }
end
