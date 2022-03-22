# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'New answer notification' do
    let(:answer) { build :answer }
    let!(:persisted_answer) { create :answer }
    let(:service) { double 'NotificationService' }

    before do
      allow(NotificationService).to receive(:new).and_return(service)
    end

    it 'calls NotificationService#new_answer after create' do
      expect(service).to receive(:new_answer).with(answer)
      answer.save!
    end

    it 'does not call NotificationService#new_answer after update' do
      expect(service).not_to receive(:new_answer).with(persisted_answer)
      persisted_answer.update!(body: 'new body')
    end
  end
end
