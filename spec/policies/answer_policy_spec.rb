require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:guest) { nil }

  subject { described_class }

  permissions :create? do
    it 'grant access if user registration' do 
      expect(subject).to permit(user)
    end

    it 'denies access if user is a guest' do 
      expect(subject).to_not permit(guest)
    end
  end

  permissions :update? do
    it 'grant access if user is author' do 
      expect(subject).to permit(user, create(:answer, author: user))
    end

    it 'denies access if user is not author' do 
      expect(subject).to_not permit(User.new, create(:answer, author: user))
    end
  end

  permissions :destroy? do
    it 'grant access if user is author' do 
      expect(subject).to permit(user, create(:answer, author: user))
    end

    it 'denies access if user is not author' do
      expect(subject).to_not permit(User.new, create(:answer, author: user))      
    end
  end

  permissions :mark_as_best? do 
    it 'grant access if user is author' do 
      expect(subject).to permit(user, create(:answer, question: create(:question, author: user)))
    end

    it 'denies access if user is not author' do 
      expect(subject).to_not permit(User.new, create(:answer, question: create(:question, author: user)))
    end
  end

  permissions :vote? do 
    it 'grant access if user is author of question' do 
      expect(subject).to permit(user, create(:answer))
    end

    it 'denies access if user is not author of question' do 
      expect(subject).to_not permit(user, create(:answer, author: user))
    end
  end
end
