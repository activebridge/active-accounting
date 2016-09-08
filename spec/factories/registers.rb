FactoryGirl.define do
  factory :register do
    date { Date.yesterday }
    type Register::TYPES::FACT
    value 100
    association :article
    association :counterparty
    association :vendor
  end

  factory :register_plan, parent: :register do
    type Register::TYPES::PLAN
  end
end
