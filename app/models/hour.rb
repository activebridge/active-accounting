class Hour < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, :month, :customer_id, :vendor_id, presence: true
  validates :hours, length: { maximum: 3 }
  delegate :name, to: :customer, prefix: true
  delegate :name, to: :vendor, prefix: true

  scope :by_month, lambda { |date|
    if date
      date = date.to_date
      where('extract(month from month) = ? AND extract(year from month) = ?', date.month, date.year)
    end
  }

  scope :hours_by_month, lambda { |year|
    where('extract(year from month) = ?', year || Date.current.year)
      .select('month(month) as report_month, sum(hours) as total_hours').group(:report_month)
  }

  scope :by_customer, lambda  { |id|
    where(customer_id: id) if id
  }

  scope :by_vendor, lambda  { |id|
    where(vendor_id: id) if id
  }

  scope :uniq_years, lambda {
    pluck(:month).map(&:year).uniq.sort
  }

  scope :find_double, lambda { |params|
    where("customer_id = #{params[:customer_id]}
            AND vendor_id = #{params[:vendor_id]}
            AND hours = #{params[:hours]}
            AND extract(month from month) = #{params[:month].month}
            AND extract(year from month) = #{params[:month].year}")
  }
end
