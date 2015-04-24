FactoryGirl.define do
  factory :client_info do
    name        { Faker::Name.name }
    agreement   { Faker::Name.name }
    invoice_id  { Faker::Number.number(8) }
    address     { Faker::Address.city }
    repr_name   { Faker::Name.name }
  end
end
