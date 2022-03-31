# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build :subscription }

  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should validate_uniqueness_of(:user).scoped_to(:question_id) }
end
