FactoryGirl.define do
  factory :client_act do
    total_money '7501.55'
    month Date.today.beginning_of_month
    association :customer, :with_monthly_payment, :with_info
  end
end
