# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now - 1.hour }
    admin { false }

    trait :invalid do
      email { nil }
      password { nil }
      password_confirmation { nil }
    end

    transient do
      questions_count { 5 }
    end

    factory :user_with_questions do
      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, author: user)
      end
    end
  end
end
