require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe 'User is' do 
    let(:user) { create(:user) }

    context 'author of resource' do 
      let(:question) { create(:question, author: user) }

      it 'true' do 
        expect(user).to be_author_of(question)
      end
    end

    context 'not author of resource' do 
      let(:question) { create(:question) }

      it 'false' do
        expect(user).to_not be_author_of(question)
      end
    end
  end
end
