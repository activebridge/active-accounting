FactoryGirl.define do
  factory :register do
    date { Date.yesterday }
    association :article
    type Register::TYPES::FACT
    value 100
  end

  factory :register_plan, parent: :register do
    type Register::TYPES::PLAN
  end
end
