class VendorInfo < ActiveRecord::Base
  belongs_to :vendor

  def short_name
    array = name.split.map(&:capitalize)
    array[0] + " #{array[1][0]}.#{array[2][0]}."
  end
end
