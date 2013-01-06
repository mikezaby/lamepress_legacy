require 'factory_girl'

FactoryGirl.define do
  factory :block do
    sequence(:name) {|n| "name#{n}" }
    sequence(:position) { |n| Random.new.rand(80) }
    mode "cover"
    partial "cover"
    sequence(:placement) {|n| "place#{n}" }

    trait :left do
      placement "left"
    end
  end
end
