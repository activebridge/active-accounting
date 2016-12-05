class Holiday < ActiveRecord::Base
  validates :name, :date, presence: true

  scope :by_year, ->(year) { where('extract(year from date) = ?', year) if year }

  scope :by_month, lambda { |date|
    where('extract(month from date) = ? AND extract(year from date) = ?', date.month, date.year)
  }
end
