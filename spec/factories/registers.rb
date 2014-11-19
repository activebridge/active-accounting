FactoryGirl.define do
  factory :register do
    date { (:date).try('month') || Date.yesterday }
    association :article
    value 100
  end
end
