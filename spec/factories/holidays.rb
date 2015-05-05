FactoryGirl.define do
  factory :holiday do
    name { Faker::Name.name }
    date { Date.yesterday }
  end
end
