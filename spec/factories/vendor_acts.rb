FactoryGirl.define do
  factory :vendor_act do
    total_money '7501.55'
    month Date.today
    association :vendor, :with_info
  end
end
