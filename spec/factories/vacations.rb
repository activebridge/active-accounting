FactoryGirl.define do
  factory :vacation do
    start Date.yesterday.strftime
    ending Date.current.strftime
  end
end
