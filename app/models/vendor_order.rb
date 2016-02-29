class VendorOrder < ActiveRecord::Base
  include ValidationOnMonth

  validate :month_uniqueness, on: :create, if: :vendor
  has_many :order_features
  has_many :features, through: :order_features
  belongs_to :vendor

  def months
    vendor.vendor_orders.map(&:month)
  end
end
