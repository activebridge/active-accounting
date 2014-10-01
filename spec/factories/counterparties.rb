FactoryGirl.define do
  factory :counterparty do
    name { Faker::Name.name }
    start_date { Date.yesterday }
    active true
  end
end
