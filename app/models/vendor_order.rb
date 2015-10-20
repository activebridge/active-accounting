class VendorOrder < ActiveRecord::Base
  validates :month, uniqueness: { message: 'Order for this month has been already created!' }

  has_many :features, through: :order_features
  has_many :order_features
  belongs_to :vendor
end
