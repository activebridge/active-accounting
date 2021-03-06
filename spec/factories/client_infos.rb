FactoryGirl.define do
  factory :client_info do
    name             { Faker::Name.name }
    agreement_number { Faker::Name.name }
    invoice_id       { Faker::Number.number(8) }
    address          { Faker::Address.city }
    repr_name        { Faker::Name.name }
    agreement_date   { Date.yesterday }
    title_en         { Faker::Name.name }
    title_ua         { Faker::Name.name }
  end
end
