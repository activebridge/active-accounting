class OrderFeature < ActiveRecord::Base
  belongs_to :vendor_order
  belongs_to :feature
end
