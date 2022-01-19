# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    user { nil }
    provader { 'MyString' }
    uid { 'MyString' }
  end
end
