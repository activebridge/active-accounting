# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :register do
    date "2014-10-03"
    article_id 1
    counterparty_id 1
    value 1
    notes "MyText"
  end
end
