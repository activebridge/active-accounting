FactoryGirl.define do
  factory :counterparty do
    name { Faker::Name.name }
    start_date { Date.yesterday }
    active true
    type { Counterparty::TYPES::DISPLAY_TYPES[0] }
    currency_monthly_payment 'USD'

    factory :customer, parent: :counterparty, class: 'Customer' do
      type 'Customer'

      trait :with_monthly_payment do
        monthly_payment true
        value_payment 15
        after(:create) do |c|
          c.hours = create_list(:hour, 1)
        end
      end

      trait :with_info do
        after(:create) do |c|
          c.client_info.attributes = attributes_for :client_info
          c.client_info.save
        end
      end

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
