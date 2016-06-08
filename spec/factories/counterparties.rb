FactoryGirl.define do
  factory :counterparty do
    name { Faker::Name.name }
    start_date { Date.yesterday }
    active true
    type { Counterparty::TYPES::DISPLAY_TYPES[0] }
    currency_monthly_payment 'USD'

    factory :customer, parent: :counterparty, class: 'Customer' do
      type 'Customer'
    end

    factory :vendor, parent: :counterparty, class: 'Vendor' do
      type 'Vendor'
      email { Faker::Internet.email }
      password { Faker::Internet.password(8) }

      trait :with_info do
        after :create do |v|
          v.vendor_info.update(attributes_for(:vendor_info))
        end
      end
    end

    factory :hr, parent: :counterparty, class: 'HR' do
      type 'HR'
      email { Faker::Internet.email }
      password { Faker::Internet.password(8) }
    end
  end
end
