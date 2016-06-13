class VendorOrder < ActiveRecord::Base
  include ValidationOnMonth
  include ValidationInfoVendor
  include HasSignature

  validate :month_uniqueness, on: :create, if: :vendor
  has_and_belongs_to_many :features, dependent: :destroy
  belongs_to :vendor

  after_create :set_features

  def months
    vendor.vendor_orders.pluck(:month)
  end

  private

  def set_features
    features << Feature.all
  end
end
