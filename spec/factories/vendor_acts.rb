FactoryGirl.define do
  factory :vendor_act do
    total_money '7501.55'
    month Date.today

    trait :for_signature
  end
end
