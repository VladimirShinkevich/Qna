require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe "find_vote" do
    let(:user) { create(:user) }

    context "return vote" do
      let(:question) { create(:question) }
      let!(:vote) { create(:vote, author: user, votable: question) }

      it "user has vote for question" do
        expect(user.find_vote(question)).to eq vote
      end
    end

    context "return nil" do
      let(:question) { create(:question) }
      let!(:vote) { create(:vote, author: user) }

      it "user has no vote for question" do
        expect(user.find_vote(question)).to be_nil
      end
    end
  end

  describe '.find_for_oauth' do 
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth')} 

    it 'calls FindForOauth' do 
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
