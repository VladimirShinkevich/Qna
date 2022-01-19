# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'http://google.ru' }
  end
end
