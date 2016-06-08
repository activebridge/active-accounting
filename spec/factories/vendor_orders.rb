FactoryGirl.define do
  factory :vendor_order do
    month Date.today
    association :vendor, :with_info
  end
end
