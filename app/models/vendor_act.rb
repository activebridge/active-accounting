class VendorAct < ActiveRecord::Base
  validates :month, uniqueness: { message: 'Act for this month has been created already!' }

  belongs_to :vendor
end
