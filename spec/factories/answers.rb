FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :without_question do
    body { 'MyAnswer' }
  end
  end
end
