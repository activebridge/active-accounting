FactoryGirl.define do
  TYPES = Counterparty::TYPES.constants.map(&:to_s)
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

    factory :hr, parent: :counterparty, class: 'HR' do
      type 'HR'
      email { Faker::Internet.email }
      password { Faker::Internet.password(8) }
    end
  end
end
