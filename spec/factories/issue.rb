require 'factory_girl'

FactoryGirl.define do
  factory :issue do
    sequence(:number) {|n| n }
    date "2010-02-23"
    cover { File.new(Rails.root.join('spec', 'fixtures', 'issue.png')) }
    pdf { File.new(Rails.root.join('spec', 'fixtures', 'issue.pdf')) }

    factory :public_issue do
      published true
    end
  end
end