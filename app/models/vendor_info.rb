class VendorInfo < ActiveRecord::Base
  belongs_to :vendor

  def short_name
    name.split(' ').map { |s| if name.split(' ').rindex(s) > 0 then s[0] + '.' else s + ' ' end }.join if name
  end
end
