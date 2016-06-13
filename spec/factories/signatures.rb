# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :signature do
    name_ua { Faker::Name.name }
    name_en { Faker::Name.name }
    title_ua 'CEO'
    title_en 'CEO'
    email { Faker::Internet.email }
  end
end
