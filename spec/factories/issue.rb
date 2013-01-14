require 'factory_girl'

FactoryGirl.define do
  factory :issue do
    sequence(:number) {|n| n }
    date Date.today
    cover Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/issue.png'),
                                                       'image/png')
    pdf Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/issue.pdf'),
                                                     'application/pdf')
    published false

    trait :public do
      published true
    end

    trait :next_month do
      date 1.month.from_now.to_date
    end

    trait :previus_month do
      date 1.month.ago.to_date
    end

    factory :public_issue, traits: [:public]
  end
end