require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { create :vote }

  it { should belong_to(:votable) }
  it { should belong_to(:author) }
  it { should validate_presence_of :status }
  it { should validate_uniqueness_of(:author_id).scoped_to(:votable_type, :votable_id) }
  it { should define_enum_for(:status).with_values(like: 1, dislike: -1) }
end
