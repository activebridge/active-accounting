FactoryGirl.define do
  factory :hour do
    month Date.current.beginning_of_month
    hours 150
  end
end
