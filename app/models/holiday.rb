class Holiday < ActiveRecord::Base
  validates :name, :date, presence: true

  scope :by_year, -> (year) { where("extract(year from date) = ?", year) }
end
