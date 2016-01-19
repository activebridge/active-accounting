class Hour < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, :month, :customer_id, :vendor_id, presence: true

  delegate :name, to: :customer, prefix: true
  delegate :name, to: :vendor, prefix: true

  scope :by_month, -> (date) {
    date = date.to_date
    where("extract(month from month) = ? AND extract(year from month) = ?", date.month, date.year)
  }

  scope :hours_by_month, -> (year) {
    where("extract(year from month) = ?", year || Date.current.year)
    .select("month(month) as report_month, sum(hours) as total_hours").group(:report_month)
  }

  scope :by_customer, -> (id) {
    where(customer_id: id) if id
  }

  scope :by_vendor, -> (id) {
    where(vendor_id: id) if id
  }

  scope :uniq_years, -> {
    pluck(:month).map(&:year).uniq.sort
  }

  scope :find_double, -> (params) {
    where("customer_id = #{params[:customer_id]}
            AND vendor_id = #{params[:vendor_id]}
            AND hours = #{params[:hours]}
            AND extract(month from month) = #{params[:month].month}
            AND extract(year from month) = #{params[:month].year}")
  }

  scope :total_hours, -> {
    pluck("hours").inject(:+)
  }
end
