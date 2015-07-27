class VendorOrder < ActiveRecord::Base
  has_many :features, through: :order_features
  has_many :order_features
  belongs_to :vendor
end
