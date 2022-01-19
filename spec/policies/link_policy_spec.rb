# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:question) { create(:question, :with_link, author: user) }

  subject { described_class }

  permissions :destroy? do
    it 'grant access if user is admin' do
      expect(subject).to permit(admin)
    end

    it 'grant access if user is a author of link' do
      expect(subject).to permit(user, question.links.first)
    end

    it 'denies access if user is not author of link' do
      expect(subject).to_not permit(User.new, question.links.first)
    end
  end
end
