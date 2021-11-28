FactoryBot.define do
  factory :vote do
    association :author, factory: :user
    association :votable, factory: :question
  end
end
