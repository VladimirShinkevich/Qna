FactoryBot.define do
  factory :comment do
    association :author, factory: :user
    association(:commentable, factory: :question)
    sequence(:body) { |n| "My coment #{n}" }
  end
end
