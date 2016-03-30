class Vacation < ActiveRecord::Base
  DAYS = 15

  belongs_to :vendor

  validates :start, :ending, :vendor_id, presence: true
  validates :start, :ending, uniqueness: true

  scope :by_year, -> (year) { where('extract(year from start) = ?', year) if year }
end
