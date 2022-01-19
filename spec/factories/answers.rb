# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :answer_with_files do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'rails_helper.rb'
        )
      end
    end

    trait :without_question do
      body { 'MyAnswer' }
    end
  end
end
