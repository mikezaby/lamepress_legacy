require 'factory_girl'

FactoryGirl.define do
  factory :page do
    sequence(:name) {|n| "name#{n}" }
    sequence(:title) {|n| "title#{n}" }
    sequence(:permalink) {|n| "title #{n}" }
    meta_description "A random description"
    content "A random content"
    published true

    trait :unpublished do
      published false
    end
  end
end
