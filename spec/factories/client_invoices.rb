FactoryGirl.define do
  factory :client_invoice do
    month Date.today.beginning_of_month

    trait :for_signature do
      association :customer, :with_monthly_payment, :with_info
    end
  end
end
