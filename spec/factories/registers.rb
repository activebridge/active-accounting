FactoryGirl.define do
  factory :register do
    date { Date.yesterday }
    association :article
    value 100
  end
end
