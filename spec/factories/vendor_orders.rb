FactoryGirl.define do
  factory :vendor_order do
    month Date.today
    association :vendor, :with_info

    trait :for_signature
  end
end
