class VendorAct < ActiveRecord::Base
  validates :month, uniqueness: { message: 'Act for this month has been already created!' }

  belongs_to :vendor
end
