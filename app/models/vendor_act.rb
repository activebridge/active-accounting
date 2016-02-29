class VendorAct < ActiveRecord::Base
  include ValidationOnMonth

  validate :month_uniqueness, on: :create, if: :vendor
  belongs_to :vendor

  def months
    vendor.vendor_acts.map(&:month)
  end
end
