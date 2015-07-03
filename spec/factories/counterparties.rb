FactoryGirl.define do
  TYPES = ['Customer', 'Vendor', 'Other']
  factory :counterparty do
    name { Faker::Name.name }
    start_date { Date.yesterday }
    active true
    type {TYPES[rand(1)]}
    currency_monthly_payment "USD"

    factory :customer, parent: :counterparty, class: 'Customer' do
      type 'Customer'
    end

    factory :vendor, parent: :counterparty, class: 'Vendor' do
      type 'Vendor'
      email { Faker::Internet.email }
      password { Faker::Internet.password(8) }
    end
  end
end
