# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:guest) { nil }

  subject { described_class }

  permissions :create? do
    it 'grant access if user is admin' do
      expect(subject).to permit(admin)
    end

    it 'grant access if user registration' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is a guest' do
      expect(subject).to_not permit(guest)
    end
  end
end
