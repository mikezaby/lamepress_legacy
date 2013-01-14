require 'factory_girl'

FactoryGirl.define do
  factory :tagging do
    association :article, factory: :issued_article
    association :tag, factory: :tag
  end
end