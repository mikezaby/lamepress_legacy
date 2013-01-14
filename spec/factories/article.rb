require 'factory_girl'

FactoryGirl.define do
  factory :article do
    title 'Yar Har!'
    hypertitle "Houlaboula"
    html "Random content"
    published true
    author "me"
    sequence(:date) { |n| (Date.today + n.days) }
    association :category, factory: :category

    trait :unpublished do
      published false
    end

    trait :not_issued do
      association :category, factory: :category
    end

    trait :issued do
      association :category, factory: :issued_category
      association :issue, factory: :public_issue
    end

    trait :unpublished_issue do
      association :category, factory: :issued_category
      association :issue, factory: :issue
    end

    trait :issue_ordered do
      association :ordering, factory: :issue_ordering
    end

    trait :default_order do
      association :ordering, factory: :ordering
    end

    trait :category_ordered do
      association :ordering, factory: :category_ordering
    end


    factory :issued_article, traits: [:issued, :default_order]
    factory :not_issued_article, traits: [:not_issued]
    factory :home_article, traits: [:issued, :issue_ordered]
  end
end