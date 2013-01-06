require 'factory_girl'

FactoryGirl.define do
  factory :tag do
    sequence(:name) {|n| "name#{n}" }
  end
end