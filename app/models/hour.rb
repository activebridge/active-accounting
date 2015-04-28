class Hour < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, :month, :customer_id, presence: true

  delegate :name, to: :customer, prefix: true
  delegate :name, to: :vendor, prefix: true

  scope :by_month, -> (date) {
    date = date.to_date
    where("extract(month from month) = ? AND extract(year from month) = ?", date.month, date.year)
  }

  scope :hours_by_month, -> {
    where("extract(year from month) = ?", Date.current.year)
    select("month(month) as month, sum(hours) as total_hours").group(:month)
  }

  scope :by_customer, -> (id) {
    where(customer_id: id) if id
  }
end
