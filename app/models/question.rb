class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  has_one :award, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
