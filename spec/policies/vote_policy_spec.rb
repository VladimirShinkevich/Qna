# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }

  subject { described_class }

  permissions :destroy? do
    it 'grant access if user is admin' do
      expect(subject).to permit(admin)
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:vote, author: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:vote, author: user))
    end
  end
end
