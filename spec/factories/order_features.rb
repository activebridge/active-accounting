FactoryGirl.define do
  factory :order_feature do
    vendor_order { FactoryGirl.create(:vendor_order) }
    feature { FactoryGirl.create(:primary) }
  end
end
