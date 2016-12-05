class VendorInfo < ActiveRecord::Base
  belongs_to :vendor

  def short_name
    name.split(' ').map { |s| name.split(' ').rindex(s).positive? ? s[0] + '.' : s + ' ' }.join if name
  end
end
