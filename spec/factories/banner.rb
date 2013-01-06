require 'factory_girl'

FactoryGirl.define do
  factory :banner do
    describe "A random description"
    association :block, factory: :block
    sequence(:position) { |n| Random.new.rand(80) }
    photo Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/issue.png'),
                                       'image/png')
    trait :with_url do
      url "http://www.lamezor.com"
    end
  end
end