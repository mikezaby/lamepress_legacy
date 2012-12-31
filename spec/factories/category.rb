require 'factory_girl'

FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "name#{n}" }
    issued false
    order_articles 0

    factory :issued_category do
      issued true
    end
  end
end