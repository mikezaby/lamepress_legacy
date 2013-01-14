require 'factory_girl'

FactoryGirl.define do
  factory :navigator do
    sequence(:name) {|n| "name#{n}" }
    association :block, factory: :block
    sequence(:position) { |n| Random.new.rand(80) }
    association :navigatable, factory: :category
  end
end