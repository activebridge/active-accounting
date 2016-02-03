# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tax do
    social 100
    single 1
    cash   1
  end
end
