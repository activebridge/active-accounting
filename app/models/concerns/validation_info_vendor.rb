module ValidationInfoVendor
  extend ActiveSupport::Concern

  included do
    validate :vendor_info_empty, on: :create
  end

  private

  def vendor_info_empty
    vendor.vendor_info.attributes.each do |a|
      errors.add(:you_must_fill_fields, a[0]) unless a[1]
    end
  end
end
