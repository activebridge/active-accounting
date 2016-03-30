class VendorInfo < ActiveRecord::Base
  belongs_to :vendor

  def short_name
    name.split(' ').map { |s| name.split(' ').rindex(s) > 0 ? s[0] + '.' : s + ' ' }.join if name
  end
end
