# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    name { Faker::Name.name }
    type Article::TYPES::COST
  end

  factory :revenue_article, parent: :article do
    type Article::TYPES::REVENUE
  end
end
