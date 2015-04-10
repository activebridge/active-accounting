class Estimate < ActiveRecord::Base
  belongs_to :customer
  belongs_to :vendor

  validates :hours, :month, :customer_id, presence: true
end
