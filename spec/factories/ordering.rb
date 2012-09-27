require 'factory_girl'

FactoryGirl.define do
  factory :ordering do
    cat_pos 99
    issue_pos nil

    trait :category do
      sequence(:cat_pos) { |n| Random.new.rand(80) }
    end

    trait :issue do
      sequence(:issue_pos) { |n| Random.new.rand(80) }
    end

    factory :issue_ordering, traits: [:issue]
    factory :category_ordering, traits: [:category]
  end
end