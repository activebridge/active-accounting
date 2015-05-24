FactoryGirl.define do
  factory :hour do
    month Time.current.strftime('%m/%Y').to_date
    hours 168
  end
end
