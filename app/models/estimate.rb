class Estimate < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, presence: true
end
