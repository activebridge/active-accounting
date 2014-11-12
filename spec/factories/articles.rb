# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    name { Faker::Name.name }
    type "Cost"
  end
end
