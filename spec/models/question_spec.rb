# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  subject(:question) { build :question }

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#subscribe_author' do
    it 'create subscription of author to question after create' do
      question.save
      expect(question.author).to be_subscribed(question)
    end
  end
end
