class VendorOrder < ActiveRecord::Base
  include ValidationOnMonth
  include ValidationInfoVendor
  include HasSignature

  validate :month_uniqueness, on: :create, if: :vendor
  has_many :order_features
  has_many :features, through: :order_features
  belongs_to :vendor

  after_create :set_features

  def months
    vendor.vendor_orders.map(&:month)
  end

  private

  def set_features
    features << Feature.all
  end
end
