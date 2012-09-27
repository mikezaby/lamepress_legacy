require 'factory_girl'

FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "name#{n}" }

    factory :issued_category do
      issued true
    end
  end
end