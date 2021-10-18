FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do 
      title { nil }
      body { nil }
    end

    transient do 
      answers_count { 5 }
    end

    factory :question_with_answers do 
      after(:create) do |question, evaluator| 
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    trait :with_answers do
      after :create do |question|
        create_list :answer, 3, :without_question, question: question
      end
    end
  end
end
