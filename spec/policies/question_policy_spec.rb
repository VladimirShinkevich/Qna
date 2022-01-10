require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:guest) { nil }

  subject { described_class }

  permissions :index? do
    it 'grant access if user registration' do
      expect(subject).to permit(user)
    end

    it 'grant access if user is a guest' do 
      expect(subject).to permit(guest)
    end
  end

  permissions :show? do
    it 'grant access if user registration' do
      expect(subject).to permit(user)
    end

    it 'grant access if user is a guest' do 
      expect(subject).to permit(guest)
    end
  end

  permissions :create? do
    it 'grant access if user registration' do 
      expect(subject).to permit(user)
    end

    it 'denies access if user is a guest' do 
      expect(subject).to_not permit(guest)
    end
  end

  permissions :update? do
    it 'grant access if user is a author' do 
      expect(subject).to permit(user, create(:question, author: user))
    end

    it 'denies access if user is not author' do 
      expect(subject).to_not permit(user, create(:question))
    end
  end

  permissions :destroy? do
    it 'grant access if user is a author' do 
      expect(subject).to permit(user, create(:question, author: user))
    end

    it 'denies access if user is not author' do 
      expect(subject).to_not permit(user, create(:question))
    end
  end

  permissions :vote? do 
    it 'grant access if user is a author' do 
      expect(subject).to_not permit(user, create(:question, author: user))
    end

    it 'grant access if user is a author' do 
      expect(subject).to permit(user, create(:question))
    end
  end
end
