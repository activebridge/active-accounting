FactoryGirl.define do
  factory :feature do
    name { Faker::Name.name }

    factory :primary, parent: :feature, class: 'Primary' do
      type 'Primary'
    end

    factory :additional, parent: :feature, class: 'Additional' do
      type 'Additional'
    end
  end
end
