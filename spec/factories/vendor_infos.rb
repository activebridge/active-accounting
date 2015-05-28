FactoryGirl.define do
  factory :vendor_info do
    name { Faker::Name.name }
    ipn { Faker::Number.number(8) }
    address { Faker::Address.street_address }
    contract { Faker::Name.name }
    account { Faker::Number.number(8) }
    bank { Faker::Name.name }
    mfo { Faker::Number.number(8) }
  end
end
