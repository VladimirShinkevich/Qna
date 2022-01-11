require 'rails_helper'

RSpec.describe FilePolicy, type: :policy do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :question_with_files, author: user) }
  
  subject { described_class }

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, question.files.first)
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, question.files.first)
    end
  end
end
