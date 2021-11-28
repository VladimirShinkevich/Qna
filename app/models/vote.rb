class Vote < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :votable, polymorphic: true

  validates :status, presence: true
  validates_uniqueness_of :author_id, scope: [:votable_type, :votable_id]

  enum status: { like: 1, dislike: -1 }
end
