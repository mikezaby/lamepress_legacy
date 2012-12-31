require 'factory_girl'

FactoryGirl.define do
  factory :issue do
    sequence(:number) {|n| n }
    date "2010-02-23"
    cover { File.new(Rails.root.join('spec', 'fixtures', 'issue.png')) }
    pdf { File.new(Rails.root.join('spec', 'fixtures', 'issue.pdf')) }

    trait :public do
      published true
    end

    factory :public_issue, traits: [:public]
  end
end